#!/usr/bin/env bash

set -euo pipefail


BASE="supervisor/src/main/java/ai/meta/agentic/extra/supervisor"


mkdir -p "$BASE"



cat > "$BASE/SupervisorService.java" <<EOF
package ai.meta.agentic.extra.supervisor;


import jakarta.enterprise.context.ApplicationScoped;


import ai.meta.agentic.extra.common.model.TradingSignal;



@ApplicationScoped
public class SupervisorService {



public TradingSignal decide(
        TradingSignal[] signals
){


    return signals.length == 0
            ? null
            : signals[0];


}


}
EOF


echo "Supervisor generated."
