#! /bin/sh
cd ${VENDORS}
if [ ! -e "init.lock" ]; then
    cd ${VENDORS}
    # 添加密码支持
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
   }
}
EOF
    else
        sed -i "s/DIY-PORT/"${PORT}"/g" ${VENDORS}/config.json
        sed -i "s/DIY-AC/"${ADMIN_EMAIL}"/g" ${VENDORS}/config.json
        sed -i "s/DIY-DB-SERVER/"${DB_SERVER}"/g" ${VENDORS}/config.json
        sed -i "s/DIY-DB-NAME/"${DB_NAME}"/g" ${VENDORS}/config.json
        sed -i "s/DIY-DB-PORT/"${DB_PORT}"/g" ${VENDORS}/config.json
    fi
    cp ${VENDORS}/config.json ${HOME}
    cp ${VENDORS}/config.json ${HOME}/../
    # yapi install -v 1.5.6
    yapi install -v ${VERSION}
    touch init.lock
fi

cd ${VENDORS}
# 先判断有没有CMD指定路径
if [ $1 ]; then
    node $i
else
    node server/app.js
fi
