FROM alpine:3.10
WORKDIR /package
COPY entry.sh entry.sh
RUN apk add openssh && \
    chmod +x entry.sh
ENTRYPOINT ["/package/entry.sh"]
