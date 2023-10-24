FROM elixir:1.15

ARG RUN_ENV
ENV RUN_ENV_VAR=$RUN_ENV

WORKDIR /app

ADD docker-image/elixir/startup.sh /startup.sh

RUN chmod +x /startup.sh

CMD /bin/bash /startup.sh ${RUN_ENV_VAR}