# Dockerfile for SPADE/GauGAN Training

FROM nvcr.io/nvidia/pytorch:21.06-py3

ARG DEBIAN_FRONTEND=noninteractive

# Install basics
RUN apt-get update && apt-get install -y --allow-downgrades --allow-change-held-packages --no-install-recommends \
        build-essential \
        cmake \
        git \
        curl \
        vim \
        tmux \
        wget \
        bzip2 \
        unzip \
        g++ \
        ca-certificates \
        ffmpeg \
        libx264-dev \
        imagemagick \
        libnss3-dev


WORKDIR /home
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY imaginaire-master/imaginaire/third_party/correlation correlation
RUN cd correlation && rm -rf build dist *-info && python setup.py install
COPY imaginaire-master/imaginaire/third_party/channelnorm channelnorm
RUN cd channelnorm && rm -rf build dist *-info && python setup.py install
COPY imaginaire-master/imaginaire/third_party/resample2d resample2d
RUN cd resample2d && rm -rf build dist *-info && python setup.py install
COPY imaginaire-master/imaginaire/third_party/bias_act bias_act
RUN cd bias_act && rm -rf build dist *-info && python setup.py install
COPY imaginaire-master/imaginaire/third_party/upfirdn2d upfirdn2d
RUN cd upfirdn2d && rm -rf build dist *-info && python setup.py install


COPY imaginaire-master/imaginaire/model_utils/gancraft/voxlib gancraft/voxlib

RUN cd gancraft/voxlib && make
