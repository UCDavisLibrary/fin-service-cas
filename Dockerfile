ARG CORE_SERVER_REPO_TAG
FROM ucdlib/fin-node-utils:${CORE_SERVER_REPO_TAG} as fin-node-utils
FROM node:12

COPY --from=fin-node-utils /fin-node-utils /fin-node-utils
RUN cd /fin-node-utils && npm install -g
ENV NODE_PATH /usr/local/lib/node_modules

RUN mkdir service
WORKDIR /service

COPY package.json .
COPY package-lock.json .
RUN npm install --production

COPY index.js .
COPY controller.js .

ARG CAS_SERVICE_REPO_HASH
ARG CAS_SERVICE_REPO_TAG
ENV CAS_SERVICE_REPO_HASH ${CAS_SERVICE_REPO_HASH}
ENV CAS_SERVICE_REPO_TAG ${CAS_SERVICE_REPO_TAG}

CMD node index.js