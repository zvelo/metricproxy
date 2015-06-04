FROM scratch
MAINTAINER Joshua Rubin <jrubin@zvelo.com>
EXPOSE 18080
ADD envetcd /envetcd
ENTRYPOINT ["/envetcd",              \
  "--use-default-gateway",           \
  "--system",   "metrics",           \
  "--service",  "metricproxy",       \
  "--template", "/config.json.tmpl", \
  "/metricproxy"]
CMD ["-v", "0", "-configfile", "/config.json"]
ADD metricproxy /metricproxy
ADD config.json.tmpl /config.json.tmpl
