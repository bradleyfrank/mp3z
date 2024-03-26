FROM  debian:latest
ENV   DEBIAN_FRONTEND=noninteractive
RUN   useradd --create-home mp3z \
        && apt-get update \
        && apt-get --no-install-recommends -y install ffmpeg beets \
        && apt-get clean \
        && mkdir -p \
          /home/mp3z/.config/beets \
          /home/mp3z/Music/Library \
          /home/mp3z/Music/Untagged \
          /home/mp3z/Music/Archive \
        && chown -R mp3z:mp3z /home/mp3z /usr/local/bin
USER  mp3z
COPY --chown=mp3z:mp3z --chmod=755 mp3z.sh /usr/local/bin/mp3z
COPY --chown=mp3z:mp3z --chmod=644 config.yaml /home/mp3z/.config/beets/config.yaml
