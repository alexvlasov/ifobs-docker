FROM ubuntu:16.04


ENV TERM=xterm \
    JAVA_HOME=/otp/jre1.8.0_191 \
    PATH=$PATH:/otp/jre1.8.0_191/bin

# Устанавливаем зависимости, необходимые для запуска firefox
RUN DEBIAN_FRONTEND=noninteractive apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get -y install --no-install-recommends \
    bzip2 apt-transport-https libx11-6 libfreetype6 \
    libfontconfig1 hicolor-icon-theme libxrender1 \
    libxext6 libxdamage1 libxcomposite1 libasound2 libxt6 \
    libxtst6 libdbus-glib-1-2 libxtst6 fontconfig \
    xfonts-cyrillic xfonts-100dpi ttf-ubuntu-font-family \
    ca-certificates dbus-x11 libgtk-3-0 desktop-file-utils \
    libgtk2.0-0 libcanberra-gtk3-module libcanberra-gtk-module tree \
    && fc-cache -fv \
    && apt-get clean \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*


# Копируем архивы с java и firefox esr внутрь контейнера
COPY src/* /otp/


# Создаем отдельного пользователя firefox, от которого будет запускаться наш веб проводник,
# так как от root он работать не будет. А так же подключаем и настраиваем java plugin
RUN useradd firefox -s /bin/bash -m -d /otp/firefox/ \
    && cd /otp/ && tar jxf firefox-52.9.0esr.tar.bz2 \
    && tar zxf jre-8u191-linux-x64.tar.gz \
    && mkdir -p /otp/firefox/.mozilla/plugins \
    && cd /otp/firefox/.mozilla/plugins \
    && ln -s /otp/jre1.8.0_191/lib/amd64/libnpjp2.so . \
    && chown -R firefox:firefox /otp/firefox/ \
    && echo '577fed1c21a64f2cb186c800ae467e9d' > /etc/machine-id


WORKDIR /otp/firefox/
USER firefox

#CMD ["tree"]
ENTRYPOINT ["/otp/firefox/firefox"]

