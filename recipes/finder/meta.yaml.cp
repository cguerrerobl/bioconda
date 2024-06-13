{% set name = "finder" %}
{% set version = "1.0.0" %}

package:
  name: "{{ name|lower }}"
  version: "{{ version }}"

source:
  url: "https://github.com/sagnikbanerjee15/{{ name }}/archive/{{ name }}_v{{ version }}.tar.gz"
  sha256: 7c2a5be6b3c078de780453580b51d3af01c591d7a61fc2d1437c583e24ec8ec3

build:
  number: 0
  entry_points:
    - finder=finder.__main__:finder
    
requirements:
  build:
    - {{ compiler('c') }}
    - {{ compiler('cxx') }}
  host:
    - click >=6.7
    - marshmallow >=3.0.0b2
    - pip
    - python >=3.7
    - r-base
    - zlib
    - cmake
    - htslib
  run:
    - click >=6.7
    - marshmallow >=3.0.0b2
    - python >=3.7
    - bamtools=2.5.1=he513fc3_6
    - bedops=2.4.39=hc9558a2_0
    - bedtools=2.29.2=hc088bd4_0
    - zlib
    - zstd
    - cmake
    - samtools
test:
  imports:
    - finder
  commands:
    - finder --help

about:
  home: "https://github.com/sagnikbanerjee15/finder"
  license: MIT
  license_family: MIT
  license_file: 
  summary: "Command line interface for searching a given pattern in the given directory/file paths"
  doc_url: "https://github.com/sagnikbanerjee15/finder/README.md"
  dev_url: "https://github.com/sagnikbanerjee15/finder"

extra:
  recipe-maintainers:
    - sagnikbanerjee15

