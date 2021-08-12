FROM mcr.microsoft.com/vscode/devcontainers/universal:linux

ENV FLUTTER_HOME=/home/codespace/flutter
ENV PATH=${PATH}:${FLUTTER_HOME}/bin

ADD build.sh /tmp/build.sh
RUN /tmp/build.sh
