# ---- Base Node ----
FROM rentpath/rp_node_alpine:node-v10.4.1_yarn-v1.7.0 AS base

WORKDIR /agjs

COPY package.json yarn.lock /agjs/
RUN chown -R node:node /agjs
USER node

# ---- Sidecar ----
FROM base AS sidecar

USER root

## gh-status-reporter and deps
RUN apk update \
  && apk add ca-certificates wget nodejs groff less python py-pip findutils file git make curl jq g++ \
  && update-ca-certificates \
  && pip install awscli

RUN npm i -g npm

RUN npm i -g yarn pkg

RUN yarn config set registry https://registry.yarnpkg.com \
  && yarn --pure-lockfile

COPY . /agjs

RUN yarn run buildalpine

CMD sh
