FROM gitpod/workspace-full

ENV FLUTTER_HOME=/home/gitpod/fvm/default
ENV PATH=${PATH}:${FLUTTER_HOME}/bin

RUN brew tap leoafarias/fvm && brew install fvm
RUN fvm install stable && fvm global stable
RUN flutter precache && flutter doctor -v
