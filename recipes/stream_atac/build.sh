#!/bin/bash
conda install libgfortran
$PYTHON setup.py install --single-version-externally-managed --record=record.txt