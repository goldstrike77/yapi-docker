#!/bin/bash
# 安装位置根据变量VENDORS定义
# yapi要求config.json在HOME目录,而vendors为程序运行入口目录
# yapi-cli要求config.json在当前目录下,并且能连接mongodb

# 定义一些默认参数
mail_enable=${MAIL_ENABLE:-false}
mail_host=${MAIL_HOST:-smtp.163.com}
mail_port=${MAIL_PORT:-465}
mail_user=${MAIL_USER:-yapi@163.com}
mail_pass=${MAIL_PASS:-yapi}
VENDORS=${HOME}/vendors
PLUGINS=${PLUGINS}

# 切换至安装目录
[ ! -d "$VENDORS" ] && mkdir -p "$VENDORS"

function check_in_china() {
    # 判断是否在国内,加快安装速度
    ret=`curl -s  https://api.ip.sb/geoip | grep China | wc -l`
    if [ $ret -ne 0 ]; then
        GIT_URL=${GIT_MIRROR_URL}
        npm config set registry https://registry.npm.taobao.org
        npm config set sass-binary-site http://npm.taobao.org/mirrors/node-sass
    fi
}

function install_yapi() {
    cd ${HOME}
    # 判断是否在安装目录已经安装
    if [ ! -e "init.lock" ]; then
        if [ ! -e "config.json" ]; then
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
    "enable": "${mail_enable}",
    "host": "${mail_host}",
    "port": "${mail_port}",
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
    "port": "${DB_PORT}"
   },
  "mail": {
    "enable": "${mail_enable}",
    "host": "${mail_host}",
    "port": "${mail_port}",
    "from": "${mail_user}",
    "auth": {
      "user": "${mail_user}",
      "pass": "${mail_pass}"
    }
  }
}
EOF
            fi
        else
            echo "使用已存在的config.json"
        fi
        # 安装指定版本yapi
        if [ "${HOME}" != "/home" ]; then
            yapi-cli install -v ${VERSION}
            cd $VENDORS
            # 有bug，缺少qs 
            npm install qs
        fi
        cd ${HOME}
        touch init.lock
    fi
}

function init_yapi() {
    # 初始化管理员帐户
    cd ${HOME}
    [ -s init.lock ] && return 0
    rm -f init.lock
    cd ${VENDORS}
    npm run install-server && echo inited >> ${HOME}/init.lock
}

function install_plugins() {
    # 安装插件
    while [ $# != 0 ]; do
        yapi-cli plugin --name $1
        shift
    done
}


check_in_china
install_yapi
init_yapi

# 安装插件
if [ ! -z "${PLUGINS}" ]; then
    cd ${HOME}
    npm install -g ykit
    install_plugins ${PLUGINS}
fi

cd ${VENDORS}
# 先判断有没有CMD指定路径
if [ $1 ]; then
    node $i
else
    #node server/app.js
    npm start
fi

exec "$@"
