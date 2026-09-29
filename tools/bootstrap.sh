#!/usr/bin/env bash

set -euo pipefail

PROJECT_ROOT=$(pwd)

echo "======================================="
echo " eXtra Trading Platform Bootstrap"
echo " Quarkus + Java 21 + Maven"
echo "======================================="

MODULES=(
    common
    market-data
    strategy-engine
    supervisor
    risk
    portfolio
    execution
    backtesting
    notification
)

BASE_PACKAGE="com.extra"


echo "[1/8] Creating modules..."

for MODULE in "${MODULES[@]}"
do
    mkdir -p \
    "$MODULE/src/main/java/$BASE_PACKAGE/$MODULE" \
    "$MODULE/src/main/resources" \
    "$MODULE/src/test/java/$BASE_PACKAGE/$MODULE"

done


echo "[2/8] Creating parent pom.xml..."


cat > pom.xml <<'EOF'
<project xmlns="http://maven.apache.org/POM/4.0.0">

<modelVersion>4.0.0</modelVersion>

<groupId>com.extra</groupId>
<artifactId>extra-trading-platform</artifactId>
<version>1.0-SNAPSHOT</version>

<packaging>pom</packaging>


<modules>
    <module>common</module>
    <module>market-data</module>
    <module>strategy-engine</module>
    <module>supervisor</module>
    <module>risk</module>
    <module>portfolio</module>
    <module>execution</module>
    <module>backtesting</module>
    <module>notification</module>
</modules>


<properties>

    <java.version>21</java.version>
    <quarkus.version>3.15.1</quarkus.version>

</properties>


</project>
EOF



echo "[3/8] Creating module poms..."


for MODULE in "${MODULES[@]}"
do

cat > "$MODULE/pom.xml" <<EOF
<project xmlns="http://maven.apache.org/POM/4.0.0">

<modelVersion>4.0.0</modelVersion>


<parent>
    <groupId>com.extra</groupId>
    <artifactId>extra-trading-platform</artifactId>
    <version>1.0-SNAPSHOT</version>
</parent>


<artifactId>$MODULE</artifactId>


<dependencies>

<dependency>
    <groupId>io.quarkus</groupId>
    <artifactId>quarkus-arc</artifactId>
</dependency>


<dependency>
    <groupId>io.quarkus</groupId>
    <artifactId>quarkus-rest</artifactId>
</dependency>


</dependencies>

</project>
EOF

done



echo "[4/8] Creating common domain..."


mkdir -p common/src/main/java/com/extra/common/model


cat > common/src/main/java/com/extra/common/model/CurrencyPair.java <<'EOF'
package com.extra.common.model;


public record CurrencyPair(

        String base,
        String quote

){

    public String symbol(){

        return base + "/" + quote;

    }

}
EOF



cat > common/src/main/java/com/extra/common/model/MarketSnapshot.java <<'EOF'
package com.extra.common.model;


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



cat > common/src/main/java/com/extra/common/model/TradingSignal.java <<'EOF'
package com.extra.common.model;


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



echo "[5/8] Creating strategy engine..."


mkdir -p strategy-engine/src/main/java/com/extra/strategy/agents



cat > strategy-engine/src/main/java/com/extra/strategy/TradingAgent.java <<'EOF'
package com.extra.strategy;


import com.extra.common.model.*;


public interface TradingAgent {


    String name();


    TradingSignal evaluate(
            MarketSnapshot snapshot
    );


}
EOF



cat > strategy-engine/src/main/java/com/extra/strategy/agents/EMAAgent.java <<'EOF'
package com.extra.strategy.agents;


import jakarta.enterprise.context.ApplicationScoped;

import com.extra.strategy.TradingAgent;
import com.extra.common.model.*;


@ApplicationScoped
public class EMAAgent implements TradingAgent {


@Override
public String name(){

    return "EMA-Agent";

}



@Override
public TradingSignal evaluate(
        MarketSnapshot snapshot
){

    return new TradingSignal(
        name(),
        snapshot.pair(),
        TradingSignal.Action.HOLD,
        0.5,
        "EMA placeholder"
    );

}


}
EOF



echo "[7/8] Creating execution/risk skeletons..."

# Risk module
mkdir -p risk/src/main/java/com/extra/risk

cat > risk/src/main/java/com/extra/risk/RiskService.java <<'EOF'
package com.extra.risk;

import jakarta.enterprise.context.ApplicationScoped;

@ApplicationScoped
public class RiskService {

    public boolean allowed() {
        return true;
    }

}
EOF


# Execution module
mkdir -p execution/src/main/java/com/extra/execution

cat > execution/src/main/java/com/extra/execution/ExecutionService.java <<'EOF'
package com.extra.execution;

import jakarta.enterprise.context.ApplicationScoped;

@ApplicationScoped
public class ExecutionService {

    public void execute() {
        System.out.println("Paper execution");
    }

}
EOF


echo "[8/8] Creating Docker and documentation..."


mkdir -p docker


cat > docker/docker-compose.yml <<'EOF'
services:

  postgres:
    image: postgres:16
    environment:
      POSTGRES_USER: extra
      POSTGRES_PASSWORD: extra
      POSTGRES_DB: trading


  kafka:
    image: apache/kafka:latest
    ports:
      - "9092:9092"

EOF



cat > README.md <<'EOF'
# eXtra Trading Platform

Agent-based quantitative trading platform.

## Stack

- Java 21
- Quarkus
- Kafka
- PostgreSQL
- Kubernetes

## Modules

- market-data
- strategy-engine
- supervisor
- risk
- portfolio
- execution
- backtesting


## Build

```bash
mvn clean install

