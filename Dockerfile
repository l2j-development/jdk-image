FROM debian:12.2

WORKDIR /servers

ENV LANG=C.UTF-8

RUN apt-get update && apt-get install -y locales nano zip unzip git ant htop

RUN mkdir ./temp_jdk && \
    curl -L -o ./temp_jdk/jdk.tar.gz https://download.oracle.com/java/17/archive/jdk-17.0.6_linux-x64_bin.tar.gz && \
    cd ./temp_jdk && \
    tar -xvf jdk.tar.gz && \
    mkdir -p /usr/lib/jvm && \
    mv jdk-17.0.6 /usr/lib/jvm/jdk-17 && \
    update-alternatives --install "/usr/bin/java" "java" "/usr/lib/jvm/jdk-17/bin/java" 1 && \
    update-alternatives --install "/usr/bin/javac" "javac" "/usr/lib/jvm/jdk-17/bin/javac" 1 && \
    update-alternatives --set java /usr/lib/jvm/jdk-17/bin/java && \
    update-alternatives --set javac /usr/lib/jvm/jdk-17/bin/javac && \
    rm -fr ./temp_jdk

# Для работы с базой данных
RUN apt-get install mariadb-client -y

# Удаляем curl и чистим лишнее
RUN apt-get purge curl -y && apt-get autoremove --purge -y && apt-get autoclean -y && apt-get clean -y

# id пользователя должен совпадать с id пользователем в системе где билдится данный образ
RUN groupadd -g 1000 l2j && useradd -u 1000 -ms /bin/bash -g l2j l2j
USER l2j