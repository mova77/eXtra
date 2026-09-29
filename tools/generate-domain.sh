#!/usr/bin/env bash

set -euo pipefail


PACKAGE="ai.meta.agentic.extra.common"


BASE="common/src/main/java/ai/meta/agentic/extra/common"


mkdir -p "$BASE/model"


cat > "$BASE/model/CurrencyPair.java" <<EOF
package $PACKAGE.model;


public record CurrencyPair(

        String base,

        String quote

){

    public String symbol(){

        return base + "/" + quote;

    }

}
EOF



cat > "$BASE/model/MarketSnapshot.java" <<EOF
package $PACKAGE.model;


import java.time.Instant;


public record MarketSnapshot(

        CurrencyPair pair,

        double bid,

        double ask,

        double close,

        Instant timestamp

){

    public double mid(){

        return (bid + ask) / 2;

    }

}
EOF



cat > "$BASE/model/TradingSignal.java" <<EOF
package $PACKAGE.model;


public record TradingSignal(

        String agent,

        CurrencyPair pair,

        Action action,

        double confidence,

        String reason

){


public enum Action {

    BUY,

    SELL,

    HOLD

}


}
EOF


echo "Domain classes generated.
