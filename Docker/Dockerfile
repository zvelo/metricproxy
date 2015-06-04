FROM scratch
MAINTAINER Joshua Rubin <jrubin@zvelo.com>
ENV ETCD_USE_DEFAULT_GATEWAY true
ENV ENVETCD_TEMPLATES /config.json.tmpl
ENV ENVETCD_SYSTEM metrics
ENV ENVETCD_SERVICE metricproxy
ENTRYPOINT ["/envetcd", "/metricproxy"]
CMD ["-configfile", "/config.json"]
EXPOSE 18080
ADD envetcd /envetcd
ADD metricproxy /metricproxy
ADD config.json.tmpl /config.json.tmpl
