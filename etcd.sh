#!/bin/sh

etcdctl rm --recursive /config/service/metricproxy

if [ -n "$SIGNALFX_TOKEN" ]; then
    etcdctl set /config/service/metricproxy/forward/signalfx/token "$SIGNALFX_TOKEN"
fi

## UNCOMMENT TO ENABLE WRITING TO CARBON, PRIMARILY FOR DEVELOPMENT PURPOSES ONLY
#etcdctl set /config/service/metricproxy/forward/use-carbon true

## OPTIONAL SETTINGS
#etcdctl set /config/service/metricproxy/stats-delay null # or duration, with quotes, like '"1s"'
#etcdctl set /config/service/metricproxy/listen/timeout 30s
#etcdctl set /config/service/metricproxy/forward/signalfx/url https://ingest.signalfx.com/v2/datapoint
#etcdctl set /config/service/metricproxy/forward/buffer-size 1000000
#etcdctl set /config/service/metricproxy/forward/draining-threads 10
#etcdctl set /config/service/metricproxy/forward/max-drain-size 3000
#etcdctl set /config/service/metricproxy/forward/timeout 60s
#etcdctl set /config/service/metricproxy/forward/format-version 3
#etcdctl set /config/service/metricproxy/forward/carbon-host 172.17.8.101
