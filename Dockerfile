FROM node:lts-jessie

MAINTAINER ygqygq2<29ygq@sina.com>

# yapi默认安装文件在/home/vendors下

# 默认环境变量
ENV VERSION=1.7.2 \
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
COPY config.json ${HOME}/

RUN rm -rf node && \
  ret=`curl -s  https://api.ip.sb/geoip | grep China | wc -l` && \
  if [ $ret -ne 0 ]; then \
      GIT_URL=${GIT_MIRROR_URL}; \
      npm config set registry https://registry.npm.taobao.org; \
      npm config set sass-binary-site http://npm.taobao.org/mirrors/node-sass; \
  fi; \
  echo ${GIT_URL} && \
  git clone --depth 1 ${GIT_URL} vendors && \
  cd vendors && \
  npm install -g node-gyp yapi-cli && \
  npm install --production && \
  chmod +x /bin/entrypoint.sh && \
  chmod +x /wait-for-it.sh

EXPOSE ${PORT}
ENTRYPOINT ["entrypoint.sh"]
