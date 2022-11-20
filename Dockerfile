FROM node:lts-jessie

WORKDIR /yapi
#RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories && apk add --no-cache curl wget cmake build-base git bash make gcc g++ zlib-dev autoconf automake file nasm python2

# 默认环境变量
ENV VERSION=1.9.2 \
  HOME="/yapi" \
  PORT=3000 \
  ADMIN_EMAIL="admin@admin.com" \
  DB_SERVER="mongo" \
  DB_NAME="yapi" \
  DB_PORT=27017 \
  VENDORS=/yapi/vendors \
  GIT_URL=https://github.com/YMFE/yapi.git \
  GIT_MIRROR_URL=https://gitee.com/mirrors/YApi.git

WORKDIR ${HOME}

# 拷贝相关文档至默认位置
COPY entrypoint.sh /bin/
COPY wait-for-it.sh /
COPY config.json /yapi
COPY yapi-plugin-ms-oauth /yapi/yapi-plugin-ms-oauth

RUN rm -rf node && \
  GIT_URL=${GIT_MIRROR_URL}; \
  npm config set registry https://registry.npm.taobao.org; \
  npm config set sass-binary-site http://npm.taobao.org/mirrors/node-sass; \
  echo ${GIT_URL} && \
  git clone -b v${VERSION} --depth 1 ${GIT_URL} vendors && \
  cd vendors && \
  npm install -g node-gyp yapi-cli ykit && \
  npm install --production && \
  cp -r /yapi/yapi-plugin-ms-oauth ./ && \
  npm install ./yapi-plugin-ms-oauth && \
  ykit pack -m && \
  npm cache clean --force && \
  chmod +x /bin/entrypoint.sh && \
  chmod +x /wait-for-it.sh

EXPOSE ${PORT}
ENTRYPOINT ["entrypoint.sh"]
