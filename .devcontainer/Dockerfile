FROM mcr.microsoft.com/vscode/devcontainers/universal:linux

ENV FLUTTER_HOME=/home/codespace/fvm/default
ENV PATH=${PATH}:${FLUTTER_HOME}/bin

RUN /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" < /dev/null \
  && echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /home/codespace/.profile

ADD build.sh /tmp/build.sh
RUN eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" \
  && /tmp/build.sh
