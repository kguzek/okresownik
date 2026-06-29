#!/bin/bash

set -euo pipefail

APP_VERSION=$(git describe --tags --dirty --always 2>/dev/null || echo "dev") podman compose build "$@"
