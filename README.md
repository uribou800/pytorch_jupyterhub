# pytorch_jupyterhub

## 概要
dockerでpytorchとjupyterlabを使えるようにする

## 使い方
```
# build
$ docker build -t pytorch-lab --build-arg LOCAL_UID=$(id -u $USER) --build-arg LOCAL_GID=$(id -g $USER) ./

# jupyter起動
# pytorch_workspaceをマウントしたい場合
# localhost:8080アクセスで使える
# localhost:8080/treeでいつものnotebookが使える
$ docker run -d -v $PWD/pytorch_workspace:/home/devel/workspace -p 8080:8080 --name pytorch_`whoami` pytorch-lab jupyter lab


# bash起動
$ docker run -itd -v $PWD/pytorch_workspace:/home/devel/workspace -p 8080:8080 --name pytorch_`whoami` pytorch-lab /bin/bash

# 既存コンテナへのbashログイン
$ docker exec -i -t pytorch_`whoami` bash

# コンテナの再起動
$ docker start pytorch_`whoami`

# コンテナの停止
$ docker stop pytorch_`whoami`

# コンテナの削除
$ docker rm pytorch_`whoami`

# イメージの削除
$ docker rmi pytorch-lab
```

## その他dockerでよく使うコマンド
```
# イメージの一覧
$ docker images

# コンテナの一覧
$ docker ps -a
```

## 参考
基本の形
- https://qiita.com/radiol/items/48909d69ba8114edcbf2
ユーザの追加
- https://zukucode.com/2019/06/docker-user.html