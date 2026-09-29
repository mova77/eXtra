#!/usr/bin/env bash

set -euo pipefail


BASE="strategy-engine/src/main/java/ai/meta/agentic/extra/strategy"


mkdir -p "$BASE/agent"



cat > "$BASE/agent/TradingAgent.java" <<EOF
package ai.meta.agentic.extra.strategy.agent;


import ai.meta.agentic.extra.common.model.MarketSnapshot;

import ai.meta.agentic.extra.common.model.TradingSignal;



public interface TradingAgent {


    String name();


    TradingSignal evaluate(
            MarketSnapshot snapshot
    );


}
EOF



cat > "$BASE/agent/AgentRegistry.java" <<EOF
package ai.meta.agentic.extra.strategy.agent;


import jakarta.enterprise.context.ApplicationScoped;

import java.util.List;



@ApplicationScoped
public class AgentRegistry {


private final List<TradingAgent> agents;



public AgentRegistry(
        List<TradingAgent> agents
){

    this.agents = agents;

}



public List<TradingAgent> agents(){

    return agents;

}


}
EOF


echo "Agent engine generated."
