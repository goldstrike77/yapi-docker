FROM node:12.22.12-alpine3.15

MAINTAINER ygqygq2<29ygq@sina.com>

# yapi默认安装文件在/home/vendors下

# 默认环境变量
ENV VERSION=1.9.2 \
  HOME="/home" \
  PORT=3000 \
  ADMIN_EMAIL="admin@admin.com" \
  DB_SERVER="mongo" \
  DB_NAME="yapi" \
  DB_PORT=27017 \
  VENDORS=/home/vendors \
  GIT_URL=https://github.com/YMFE/yapi.git \
  GIT_MIRROR_URL=https://gitee.com/mirrors/YApi.git

WORKDIR ${HOME}/

# 拷贝相关文档至默认位置
COPY entrypoint.sh /bin/
COPY wait-for-it.sh /

# 安装构建工具
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apk/repositories
RUN apk add --update --no-cache ca-certificates curl wget cmake build-base git bash make gcc g++ zlib-dev autoconf automake file nasm python3

RUN rm -rf node && \
  GIT_URL=${GIT_MIRROR_URL}; \
  npm config set registry https://registry.npm.taobao.org; \
  npm config set sass-binary-site http://npm.taobao.org/mirrors/node-sass; \
  echo ${GIT_URL} && \
  git clone -b v${VERSION} --depth 1 ${GIT_URL} vendors && \
  cd vendors && \
  npm install -g node-gyp yapi-cli ykit && \
  npm install --production && \
  cd .. && \
  cp vendors/config_example.json ./config.json && \
  npm cache clean --force && \
  yapi plugin --name yapi-plugin-ms-oauth && \
  chmod +x /bin/entrypoint.sh && \
  chmod +x /wait-for-it.sh

EXPOSE ${PORT}
ENTRYPOINT ["entrypoint.sh"]