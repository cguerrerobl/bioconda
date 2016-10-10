import os
import subprocess as sp
import pytest
from textwrap import dedent
import yaml
import tempfile
import requests
from bioconda_utils import utils
from bioconda_utils import docker_utils
from bioconda_utils import cli


from helpers import built_package_path, ensure_missing, Recipes, tmp_env_matrix



def test_get_deps():
    r = Recipes(dedent(
        """
        one:
          meta.yaml: |
            package:
              name: one
              version: 0.1
        two:
          meta.yaml: |
            package:
              name: two
              version: 0.1
            requirements:
              build:
                - one
        three:
          meta.yaml: |
            package:
              name: three
              version: 0.1
            requirements:
              build:
                - one
              run:
                - two
    """), from_string=True)
    r.write_recipes()
    assert list(utils.get_deps(r.recipe_dirs['two'])) == ['one']
    assert list(utils.get_deps(r.recipe_dirs['three'], build=True)) == ['one']
    assert list(utils.get_deps(r.recipe_dirs['three'], build=False)) == ['two']


def _single_build(docker_builder=None):
    """
    Tests the building of a single configured recipe, with or without docker
    """
    r = Recipes('test_case.yaml')
    r.write_recipes()
    env_matrix = list(utils.EnvMatrix(tmp_env_matrix()))[0]
    conda_bld = docker_utils.get_host_conda_bld()
    built_package = os.path.join(conda_bld, 'linux-64', 'one-0.1-0.tar.bz2')
    ensure_missing(built_package)
    utils.build(
        recipe=r.recipe_dirs['one'],
        recipe_folder='.',
        docker_builder=docker_builder,
        env=env_matrix)
    assert os.path.exists(built_package)
    ensure_missing(built_package)


def test_single_build():
    _single_build(docker_builder=None)


def test_single_build_docker_with_post_test():
    docker_builder = docker_utils.RecipeBuilder(verbose=True)
    r = Recipes('test_case.yaml')
    r.write_recipes()
    env_matrix = list(utils.EnvMatrix(tmp_env_matrix()))[0]
    conda_bld = docker_utils.get_host_conda_bld()
    built_package = os.path.join(conda_bld, 'linux-64', 'one-0.1-0.tar.bz2')
    ensure_missing(built_package)
    utils.build(
        recipe=r.recipe_dirs['one'],
        recipe_folder='.',
        docker_builder=docker_builder,
        env=env_matrix)
    assert os.path.exists(built_package)

    docker_builder.test_recipe('one')


def test_single_build_docker():
    docker_builder = docker_utils.RecipeBuilder(verbose=True)
    _single_build(docker_builder=docker_builder)


def test_docker_builder_build():
    """
    Tests just the build_recipe method of a RecipeBuilder object.

    Makes sure the built recipe shows up on the host machine.
    """
    conda_bld = docker_utils.get_host_conda_bld()
    built_package = os.path.join(conda_bld, 'linux-64', 'one-0.1-0.tar.bz2')
    ensure_missing(built_package)
    docker_builder = docker_utils.RecipeBuilder(verbose=True)
    r = Recipes('test_case.yaml')
    r.write_recipes()
    recipe_dir = r.recipe_dirs['one']
    docker_builder.build_recipe(recipe_dir, build_args='')
    assert os.path.exists(built_package)
    os.unlink(built_package)
    assert not os.path.exists(built_package)


def test_docker_build_image_fails():
    template = dedent(
        """
        FROM {self.image}
        RUN nonexistent command
        """)
    with pytest.raises(docker_utils.DockerBuildError):
        docker_builder = docker_utils.RecipeBuilder(
            verbose=True, dockerfile_template=template)


def test_conda_purge_cleans_up():
    def tmp_dir_exists(d):
        contents = os.listdir(d)
        for i in contents:
            if i.startswith('tmp') and '_' in i:
                return True

    bld = docker_utils.get_host_conda_bld(purge=False)
    assert tmp_dir_exists(bld)
    bld = docker_utils.get_host_conda_bld(purge=True)
    assert not tmp_dir_exists(bld)


def test_local_channel():
    r = Recipes('test_case.yaml')
    r.write_recipes()
    with pytest.raises(SystemExit) as e:
        cli.build(r.basedir,
                  config={},
                  packages="*",
                  testonly=False,
                  force=False,
                  docker=True,
                  loglevel="debug",
                  )
        assert e.code == 0
    conda_bld = docker_utils.get_host_conda_bld()
    print(os.listdir(os.path.join(conda_bld, 'linux-64')))


def test_env_matrix():
    contents = {
        'CONDA_PY': ['2.7', '3.5'],
        'CONDA_BOOST': '1.60'
    }

    with open(tempfile.NamedTemporaryFile().name, 'w') as fout:
        fout.write(yaml.dump(contents, default_flow_style=False))

    e1 = utils.EnvMatrix(contents)
    e2 = utils.EnvMatrix(fout.name)
    assert e1.env == e2.env
    assert sorted(
        [sorted(i) for i in e1]) == sorted([sorted(i) for i in e2]) == [
        [
            ('CONDA_BOOST', '1.60'),
            ('CONDA_PY', '2.7'),
        ],
        [
            ('CONDA_BOOST', '1.60'),
            ('CONDA_PY', '3.5'),
        ]
    ]


def test_filter_recipes_no_skipping():
    """
    No recipes have skip so make sure none are filtered out.
    """
    r = Recipes(dedent(
        """
        one:
          meta.yaml: |
            package:
              name: one
              version: "0.1"
        """), from_string=True)
    r.write_recipes()
    env_matrix = {
        'CONDA_PY': ['2.7', '3.5'],
        'CONDA_BOOST': '1.60'
    }
    recipes = list(r.recipe_dirs.values())
    assert len(recipes) == 1
    filtered = list(
        utils.filter_recipes(recipes, env_matrix, channels=['bioconda']))
    assert len(filtered) == 1


def test_filter_recipes_skip_is_true():
    r = Recipes(dedent(
        """
        one:
          meta.yaml: |
            package:
              name: one
              version: "0.1"
            build:
              skip: true
        """), from_string=True)
    r.write_recipes()
    env_matrix = {
        'CONDA_PY': ['2.7', '3.5'],
        'CONDA_BOOST': '1.60'
    }
    recipes = list(r.recipe_dirs.values())
    filtered = list(
        utils.filter_recipes(recipes, env_matrix, channels=['bioconda']))
    assert len(filtered) == 0


def test_filter_recipes_skip_py27():
    """
    When we add build/skip = True # [py27] to recipe, it should not be
    filtered out. This is because python version is not encoded in the output
    package name, and so one-0.1-0.tar.bz2 will still be created for py35.
    """
    r = Recipes(dedent(
        """
        one:
          meta.yaml: |
            package:
              name: one
              version: "0.1"
            build:
              skip: true  # [py27]
        """), from_string=True)
    r.write_recipes()
    env_matrix = {
        'CONDA_PY': ['2.7', '3.5'],
        'CONDA_BOOST': '1.60'
    }
    recipes = list(r.recipe_dirs.values())
    filtered = list(
        utils.filter_recipes(recipes, env_matrix, channels=['bioconda']))
    assert len(filtered) == 1


def test_filter_recipes_skip_py27_in_build_string():
    """
    When CONDA_PY is in the build string, py27 should be skipped
    """
    r = Recipes(dedent(
        """
        one:
          meta.yaml: |
            package:
              name: one
              version: "0.1"
            build:
              string: {{CONDA_PY}}_{{PKG_BUILDNUM}}
        """), from_string=True)
    r.write_recipes()
    env_matrix = {
        'CONDA_PY': ['2.7', '3.5'],
    }
    recipes = list(r.recipe_dirs.values())
    filtered = list(
        utils.filter_recipes(recipes, env_matrix, channels=['bioconda']))

    # one recipe, two targets
    assert len(filtered) == 1
    assert len(filtered[0][1]) == 2

    r = Recipes(dedent(
        """
        one:
          meta.yaml: |
            package:
              name: one
              version: "0.1"
            build:
              string: {{CONDA_PY}}_{{PKG_BUILDNUM}}
              skip: True # [py27]
        """), from_string=True)
    r.write_recipes()
    env_matrix = {
        'CONDA_PY': ['2.7', '3.5'],
    }
    recipes = list(r.recipe_dirs.values())
    filtered = list(
        utils.filter_recipes(recipes, env_matrix, channels=['bioconda']))

    # one recipe, one target
    assert len(filtered) == 1
    assert len(filtered[0][1]) == 1


def test_get_channel_packages():
    with pytest.raises(requests.HTTPError):
        utils.get_channel_packages('bioconda_xyz_nonexistent_channel')
    utils.get_channel_packages('bioconda')
