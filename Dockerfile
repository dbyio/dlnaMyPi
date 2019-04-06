FROM arm32v7/debian AS BUILD

LABEL maintainer="np@bitbox.io"

RUN apt-get -qq update && \
	apt-get -qq install apt-utils libtool automake autopoint make && \
	apt-get -qq install git gettext libexif-dev libjpeg-dev libid3tag0-dev libflac-dev libvorbis-dev libsqlite3-dev libavformat-dev

USER daemon
RUN git clone https://git.code.sf.net/p/minidlna/git /tmp/sources && cd /tmp/sources && \
	git checkout -f master && \
	aclocal && autoreconf -i && autoconf && \
	automake --add-missing && ./configure && \
	make


FROM arm32v7/debian:stretch-slim
RUN apt-get -qq update && apt-get -qq upgrade && \
	apt-get -qq install libexif12 libjpeg62 libid3tag0 libflac8 libvorbis0a libsqlite3-0 libavformat57 && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/* && \
	mkdir /var/cache/minidlna /var/run/minidlna && chown daemon /var/cache/minidlna /var/run/minidlna

COPY --from=BUILD /tmp/sources/minidlnad /usr/bin/

USER daemon
VOLUME ["/media", "/etc/minidlna.conf"]
EXPOSE 8200 1900/udp

ENTRYPOINT ["/usr/bin/minidlnad", "-f", "/etc/minidlna.conf", "-S"]