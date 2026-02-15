#!/usr/bin/env bash
set -e

/usr/local/bin/fvm flutter format .
/usr/local/bin/fvm flutter analyze
/usr/local/bin/fvm flutter test
