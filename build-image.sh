#!/bin/sh

./gradlew build

docker run -v `pwd`:/work --rm oracle/graalvm-ce:1.0.0-rc9 \
    native-image --no-server \
        --class-path work/build/libs/aws.graal-1.0-SNAPSHOT.jar \
        -H:Name=aws-graal \
        -H:Class=sample.Main \
        -H:+ReportUnsupportedElementsAtRuntime \
        -H:+AllowVMInspection \
        -R:-InstallSegfaultHandler

chmod +x bootstrap

zip aws-graal.zip bootstrap aws-graal

echo deploy aws-graal.zip to AWS Lambda