FROM alpine:3.15.4


RUN apk update && apk upgrade


RUN apk add --no-cache gettext bash \
  && echo $'\
export LC_ALL=en_US.UTF-8\n\
export LANG=en_US.UTF-8\n\
set_bash_prompt() {\n\
  PS1=\'🐳 \[\e[1;35m\]\H\[\e[00m\]|\[\e[1;34m\]\W\[\e[00m\]\$ \'\n\
}\n\
PROMPT_COMMAND=set_bash_prompt\n\
' > /etc/profile.d/prompt.sh \
  && chmod 755 /etc/profile.d/prompt.sh


COPY dockerAssets/motd /etc/motd
RUN echo 'clear ; cat /etc/motd ; echo ; echo ;' > /etc/profile.d/motd.sh \
  && chmod 755 /etc/profile.d/motd.sh


RUN apk add \
  make git curl bash jq \
  gcc musl-dev g++ \
  nodejs npm \
  python3 python3-dev py3-pip \
  && curl -s https://cli-assets.heroku.com/install.sh | sh
RUN ln -s /usr/bin/python3 /usr/bin/python


COPY dockerAssets/entrypoint.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]

WORKDIR /stackhero
