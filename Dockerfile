FROM debian:stable
MAINTAINER Dennis Dryden

ENV KAFKA_VERSION "2.0.0"
ENV WHITELIST *
ENV DESTINATION_BROKERS "localhost:9093"
ENV SOURCE_ZK "localhost:2181/"
ENV SOURCE_BROKERS "localhost:9092"
ENV KAFKA_MIRROR_MAKER_OPT ""

RUN apt-get update && apt-get install -y \
    default-jre-headless \
    wget \
    && apt-get clean

RUN mkdir -p /opt/kafka && \
    wget http://mirror.ox.ac.uk/sites/rsync.apache.org/kafka/${KAFKA_VERSION}/kafka_2.11-${KAFKA_VERSION}.tgz && \
    tar --strip-components=1 -C /opt/kafka -zxf kafka_2.11-${KAFKA_VERSION}.tgz

RUN mkdir -p /etc/kafka && \
    echo "group.id=${GROUPID}" >> /etc/kafka/consumer.props && \
    echo "zookeeper.connect=${SOURCE_ZK}" >> /etc/kafka/consumer.props && \
    echo "bootstrap.servers=${SOURCE_BROKERS}" >> /etc/kafka/consumer.props && \
    echo "bootstrap.servers=${DESTINATION_BROKERS}" >> /etc/kafka/producer.props

CMD /opt/kafka/bin/kafka-mirror-maker.sh --consumer.config /etc/kafka/consumer.props --producer.config /etc/kafka/producer.props --whitelist="${WHITELIST}" $KAFKA_MIRROR_MAKER_OPT

