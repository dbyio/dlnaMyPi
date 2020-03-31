FROM arm32v7/alpine:latest AS BUILD
RUN apk update && \
	apk add --no-cache gcc musl-dev libtool automake autoconf gettext-dev make \
	bsd-compat-headers git libexif-dev \
	libjpeg-turbo-dev libid3tag-dev flac-dev libvorbis-dev sqlite-dev ffmpeg-dev
USER daemon
RUN git clone https://git.code.sf.net/p/minidlna/git /tmp/sources && cd /tmp/sources && \
	git checkout -f master && \
	aclocal && autoreconf -i && autoconf && \
	automake --add-missing && ./configure && \
	make

FROM arm32v7/alpine:latest
LABEL maintainer="np@bitbox.io"
RUN apk update && apk upgrade && \
	apk add --no-cache libexif libjpeg-turbo libid3tag flac libvorbis sqlite-libs ffmpeg-libs && \
	rm -rf /var/cache/apk/* && \
	mkdir /var/cache/minidlna /var/run/minidlna && chown daemon /var/cache/minidlna /var/run/minidlna
COPY --from=BUILD /tmp/sources/minidlnad /usr/bin/
USER daemon
VOLUME ["/media", "/etc/minidlna.conf"]
EXPOSE 8200 1900/udp
ENTRYPOINT ["/usr/bin/minidlnad", "-f", "/etc/minidlna.conf", "-S"]