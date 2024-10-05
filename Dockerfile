FROM  nvidia/cuda:12.6.0-runtime-ubuntu22.04

RUN apt update \
    && apt install -y \
    git\
    wget\
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


