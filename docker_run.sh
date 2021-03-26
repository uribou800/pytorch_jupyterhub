# pytorch_jupyterhub

## 概要
dockerでpytorchとjupyterlabを使えるようにする

## 実行手順
```
# build
$ docker build -t pytorch-lab ./
or 
$ docker build -t pytorch-lab ./ --no-cache
$ docker images

# 起動
docker run -d --rm -v pytorch_workspace:/workspace -p 8888:8888 --name pytorch pytorch-lab jupyter lab


```

## 参考
基本の形
- https://qiita.com/radiol/items/48909d69ba8114edcbf2
ユーザの追加
- https://zukucode.com/2019/06/docker-user.html