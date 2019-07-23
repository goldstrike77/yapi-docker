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
COPY entrypoint.sh /bin
COPY wait-for-it.sh /

RUN rm -rf node && \
  chmod +x /bin/entrypoint.sh && \
  chmod +x /wait-for-it.sh

EXPOSE ${PORT}
ENTRYPOINT ["entrypoint.sh"]
