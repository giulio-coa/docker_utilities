FROM alpine:latest

RUN apk -U upgrade; \
  apk cache clean; \
  apk add --no-cache socat

COPY init.sh init.sh
RUN chmod 500 init.sh

CMD [ "./init.sh" ]
