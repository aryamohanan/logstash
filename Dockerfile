FROM harbor.kore.korewireless.com/docker-base-images/logstash:7.16.2 AS build-release
RUN rm -f /usr/share/logstash/pipeline/logstash.conf
ADD pipelines/ /usr/share/logstash/pipeline/
ADD configs/ /usr/share/logstash/config/
ADD plugins/ /usr/share/logstash/plugins/
ADD output/ /usr/share/logstash/output/
ADD kafka_secrets/ /usr/share/logstash/kafka_secrets/
USER root

# Edge
FROM build-release AS edge
ENV PIPELINE_WORKERS 2
ENV MIN_PIPELINE_WORKERS 1
ENV PIPELINE_BATCH_SIZE 250
ENV MIN_PIPELINE_BATCH_SIZE 125
ENV LOG_LEVEL info
ENV HTTP_HOST 0.0.0.0
ENV PATH_LOGS /logstash_data/logs/

# Staging
FROM build-release AS staging
ENV PIPELINE_WORKERS 2
ENV MIN_PIPELINE_WORKERS 1
ENV PIPELINE_BATCH_SIZE 250
ENV MIN_PIPELINE_BATCH_SIZE 125
ENV LOG_LEVEL info
ENV HTTP_HOST 0.0.0.0
ENV PATH_LOGS /logstash_data/logs/

# Production
FROM build-release AS production
ENV PIPELINE_WORKERS 4
ENV MIN_PIPELINE_WORKERS 2
ENV PIPELINE_BATCH_SIZE 250
ENV MIN_PIPELINE_BATCH_SIZE 125
ENV LOG_LEVEL info
ENV HTTP_HOST 0.0.0.0
ENV PATH_LOGS /logstash_data/logs/