FROM alpine:latest
LABEL maintainer "John Pape <jpapejr@icloud.com>"
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
RUN apk add --update curl bash
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
RUN chmod +x kubectl && mv kubectl /usr/bin/kubectl
#Required variables
ENV TARGETRESOURCE pods
ENV APISERVER 172.21.0.1
ENV NAMESPACE default
ENV TOKEN xyz123
ENV ACTION delete
ENV TTL 6
ENV INTERVAL 10

ENTRYPOINT ["/entrypoint.sh"]
