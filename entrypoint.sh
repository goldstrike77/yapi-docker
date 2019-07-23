#!/bin/sh
# 安装位置根据变量VENDORS定义

# 定义一些默认参数
mail_enable=${MAIL_ENABLE:-false}
mail_host=${MAIL_HOST:-smtp.163.com}
mail_port=${MAIL_PORT:-465}
mail_user=${MAIL_USER:-yapi@163.com}
mail_pass=${MAIL_PASS:-yapi}
VENDORS=${HOME}/vendors


# 判断是否在国内,加快安装速度
ret=`curl -s  https://api.ip.sb/geoip | grep China | wc -l`
if [ $ret -ne 0 ]; then
    npm config set registry https://registry.npm.taobao.org
fi

# 切换至安装目录
[ ! -d "$VENDORS" ] && mkdir -p "$VENDORS"
cd ${VENDORS}

# 判断是否在安装目录已经安装
if [ ! -e "${HOME}/init.lock" ]; then
    # 判断是否有用户密码，重新设置config.json
    if [ ! -z "${DB_USER}" ] && [ ! -z "$DB_PASSWORD" ]; then 
cat > config.json <<EOF
{
  "port": "${PORT}",
  "adminAccount": "${ADMIN_EMAIL}",
  "db": {
    "servername": "${DB_SERVER}",
    "DATABASE": "${DB_NAME}",
    "port": "${DB_PORT}",
    "user": "${DB_USER}",
    "pass": "${DB_PASSWORD}",
    "authSource": ""
   },
  "mail": {
    "enable": ${mail_enable},
    "host": "${mail_host}",
    "port": ${mail_port},
    "from": "${mail_user}",
    "auth": {
      "user": "${mail_user}",
      "pass": "${mail_pass}"
    }
  }
}
EOF
    else
cat > config.json <<EOF
{
  "port": "${PORT}",
  "adminAccount": "${ADMIN_EMAIL}",
  "db": {
    "servername": "${DB_SERVER}",
    "DATABASE": "${DB_NAME}",
    "port": "${DB_PORT}",
   },
  "mail": {
    "enable": ${mail_enable},
    "host": "${mail_host}",
    "port": ${mail_port},
    "from": "${mail_user}",
    "auth": {
      "user": "${mail_user}",
      "pass": "${mail_pass}"
    }
  }
}
EOF
    fi

    # 切换回 home
    \cp config.json ../
    # 安装指定版本yapi
    cd ..
    yapi-cli install -v ${VERSION}
    touch ${HOME}/init.lock
fi

cd ${VENDORS}
# 先判断有没有CMD指定路径
if [ $1 ]; then
    node $i
else
    node server/app.js
fi
