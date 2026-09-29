#!/usr/bin/env bash

set -euo pipefail


echo "Generating eXtra ai.meta.agentic platform"


./tools/generate-packages.sh

./tools/generate-domain.sh

./tools/generate-agent-engine.sh

./tools/generate-supervisor.sh


echo ""
echo "Generation completed."
