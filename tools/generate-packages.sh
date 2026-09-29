#!/usr/bin/env bash

set -euo pipefail

ROOT_PACKAGE="ai/meta/agentic/extra"

echo "Generating Java package structure..."

MODULES=(
    common
    market
    strategy
    supervisor
    risk
    portfolio
    execution
    backtest
    mcp
)


for MODULE in "${MODULES[@]}"
do

    BASE="$MODULE/src/main/java/$ROOT_PACKAGE/$MODULE"

    echo "Creating $BASE"

    mkdir -p "$BASE"

done


echo "Package structure created."`

