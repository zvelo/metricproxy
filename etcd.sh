#!/bin/sh

etcdctl set /config/service/metricproxy/stats-delay null # or duration, with quotes, like '"1s"'
etcdctl set /config/service/metricproxy/listen/timeout 30s
#etcdctl set /config/service/metricproxy/forward/signalfx/token
etcdctl set /config/service/metricproxy/forward/signalfx/url https://ingest.signalfx.com/v2/datapoint
etcdctl set /config/service/metricproxy/forward/buffer-size 1000000
etcdctl set /config/service/metricproxy/forward/draining-threads 10
etcdctl set /config/service/metricproxy/forward/max-drain-size 3000
etcdctl set /config/service/metricproxy/forward/timeout 60s
etcdctl set /config/service/metricproxy/forward/format-version 3
