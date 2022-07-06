FROM pihole/pihole:latest

COPY unbound.sh unbound.sh

RUN ./unbound.sh && \
	rm --recursive --force unbound.sh