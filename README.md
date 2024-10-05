# NVIDIA GGPUを使用するJupyter notebookをDockerでデプロイする

### jupyter-dockerというディレクトリを作り、そのディレクトリに移動します
```
$ mkdir jupyter-docker
$ cd jupyter-docker
```

### 最終的なディレクトリの中身です
```
Dockerfile
docker-compose.yml
jupyter_notebook_config.py
notebooks/
requirements.txt
```

### Dockerfileを作ります

```
FROM  nvidia/cuda:12.6.0-runtime-ubuntu22.04

RUN apt update \
    && apt install -y \
    git\
    python3\
    python3-pip

RUN apt-get autoremove -y && apt-get clean && \
    rm -rf /usr/local/src/*

WORKDIR /notebooks

COPY requirements.txt /tmp/
COPY jupyter_notebook_config.py /tmp/

RUN pip3 install --upgrade pip
RUN pip install --no-cache-dir -r /tmp/requirements.txt

CMD ["jupyter","notebook","--port","8888","--no-browser","--allow-root","--config=/tmp/jupyter_notebook_config.py"]
```

### docker-compose.ymlを作ります

```
version: "3"
services:
  tensorflow:
    build: .
    runtime: nvidia
    environment:
      - NVIDIA_VISIBLE_DEVICES=all
    volumes:
      - ./notebooks:/notebooks
    ports:
      - 8888:8888
```

### jupyter_notebook_config.pyを作ります
```
c.NotebookApp.ip = '0.0.0.0'
c.NotebookApp.token = 'xxx'
```
0.0.0.0はローカルネットワーク上の他のコンピューターからアクセスできる設定です。xxxの部分は任意に決めてください。

### requirements.txtを作ります
```
torch
torchvision
torchaudio
tensorflow-gpu
transformers
jupyter
notebook
```

### 作成したプログラム（ノートブック）を保存するディレクトリを作ります
```
$ mkdir notebooks
```

### Docker composeコマンドでコンテナを起動します

最初に実行した際に nvidia/cuda:12.6.0-runtime-ubuntu22.04のイメージをダウンロードし、必要なライブラリのインストールが行われ、Dockerのイメージがビルドされるので、コンテナの起動に数分かかりますが、次回以降は瞬時に起動します。
```
$ docker compose up
```

### このリポジトリを使う場合

```
$ git clone https://github.com/kazz12211/jupyter-docker.git
$ cd jupyter-docker
$ docker compose up
```
