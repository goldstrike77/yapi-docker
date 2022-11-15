```hcl
sudo docker login --username=suzhetao registry.cn-hangzhou.aliyuncs.com
sudo docker build -t registry.cn-hangzhou.aliyuncs.com/goldstrike/yapi:v1.12.0 .
sudo docker push registry.cn-hangzhou.aliyuncs.com/goldstrike/yapi:v1.12.0
```