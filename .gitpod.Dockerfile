FROM gitpod/workspace-full

ENV FLUTTER_HOME=/home/gitpod/fvm/default
ENV PATH=${PATH}:${FLUTTER_HOME}/bin

ADD .devcontainer/build.sh /tmp/build.sh
RUN /tmp/build.sh
