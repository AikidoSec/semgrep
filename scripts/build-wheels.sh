#!/usr/bin/env bash
# This script build "wheels", which is a format used by the Pypi package manager
# to distribute binaries (for us semgrep-core) with regular Python code.
# See https://packaging.python.org/en/latest/glossary/#term-Wheel
# and https://realpython.com/python-wheels/ for more information.
# This script is called from our GHA build-xxx workflows.
# It assumes the semgrep-core binary has been copied under cli/src/semgrep/bin
# for pip to package semgrep correctly.

set -e
python3 -m pip install build
pip3 list
cd cli && python3 -m build --sdist --wheel
# Zipping for a stable name to upload as an artifact
zip -r dist.zip dist
