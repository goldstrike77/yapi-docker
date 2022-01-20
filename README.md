<h2 align="center">Docker for YApi</h2>
<span class="text">forked from <a data-hovercard-type="repository" data-hovercard-url="/jinfeijie/yapi/hovercard" href="https://github.com/jinfeijie/yapi">jinfeijie/yapi</a></span>
<p align="center">一键部署YApi</p>

<p align="center">ygqygq2 [29ygq@sina.com] </p>

<p align="center">
<a href="https://cloud.docker.com/u/ygqygq2/repository/docker/ygqygq2/yapi"><img src="https://img.shields.io/docker/automated/ygqygq2/yapi.svg?style=flat-square" alt=""></a>
<a href="https://github.com/ygqygq2/yapi-docker"><img src="https://img.shields.io/github/license/ygqygq2/yapi-docker.svg?style=flat-square" alt="License"></a>
</p>


## 使用
默认密码是：`ymfe.org`，安装成功后进入后台修改

## 可修改变量
| 环境变量       | 默认值         | 建议         |
| ------------- |:-------------:|:-----------:|
| VERSION | 1.8.0  | 不建议修改   |
| HOME | /home | 可修改 |  
| PORT | 3000  | 可修改 | 
| ADMIN_EMAIL | admin@admin.com | 建议修改 | 
| DB_SERVER | mongo(127.0.0.1)  | 不建议修改 |
| DB_NAME | yapi  | 不建议修改 |
| DB_PORT | 27017 | 不建议修改|
| VENDORS | ${HOME}/vendors | 不建议修改  | 


## 获取本镜像
`docker pull ygqygq2/yapi:latest`

## docker-compose 部署
`docker-compose up -d`

## Nginx 配置
```
server {
    listen     80;
    server_name your.domain;
    keepalive_timeout   70;

    location / {
        proxy_pass http://yapi:3000;
    }
    location ~ /\. {
        deny all;
    }
}
```

## 其他
📧联系[@ygqygq2](mailto29ygq@sina.com)

✨欢迎 Star && Fork
