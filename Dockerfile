FROM grafana/grafana:master
MAINTAINER Jimmi Dyson <jimmidyson@gmail.com>

ENTRYPOINT ["/run.sh"]

ENV GF_AUTH_ANONYMOUS_ENABLED true
ENV GF_DASHBOARDS_JSON_ENABLED true
ENV GF_DASHBOARDS_JSON_PATH /dashboards
ENV GF_LOG_MODE console

RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN chmod 777 /var/lib/grafana /usr/share/grafana/
RUN chown grafana /var/lib/grafana
RUN chown grafana /usr/share/grafana/

ADD debian-packages /debian-packages
RUN dpkg -i /debian-packages/*.deb

ADD run.sh /run.sh
RUN chown grafana /run.sh
RUN chmod 777 /run.sh
ADD dashboards /dashboards
RUN chmod 777 /dashboards && chmod 666 /dashboards/*

ADD grafana-kubernetes-app /usr/share/grafana/public/app/plugins/app/grafana-kubernetes-app
RUN chmod -R 777 /usr/share/grafana/public/app/plugins/app/grafana-kubernetes-app

#RUN grafana-cli plugins install raintank-kubernetes-app

ADD hawkular-datasource /usr/share/grafana/public/app/plugins/datasource/hawkular-datasource
RUN chmod 777 /usr/share/grafana/public/app/plugins/datasource/hawkular-datasource

USER grafana
