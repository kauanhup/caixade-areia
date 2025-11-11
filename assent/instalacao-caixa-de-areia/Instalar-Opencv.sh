#!/bin/bash

# --- Instalação do OpenCV mais recente ---

# Atualizar pacotes e instalar dependências
echo "→ Atualizando pacotes e instalando dependências..."
sudo apt-get update -y
sudo apt-get install -y build-essential cmake git pkg-config libgtk-3-dev \
    libavcodec-dev libavformat-dev libswscale-dev libv4l-dev \
    libxvidcore-dev libx264-dev libjpeg-dev libpng-dev libtiff-dev \
    gfortran openexr libatlas-base-dev python3-dev python3-numpy \
    libtbb2 libtbb-dev libdc1394-22-dev

# Entrar na pasta src
cd ~/src || exit 1

# Clonar o repositório oficial do OpenCV e do OpenCV contrib
echo "→ Baixando OpenCV..."
git clone https://github.com/opencv/opencv.git
git clone https://github.com/opencv/opencv_contrib.git

cd opencv || exit 1

# Criar pasta de build
mkdir -p build && cd build || exit 1

# Executar cmake
echo "→ Configurando build do OpenCV..."
cmake -D CMAKE_BUILD_TYPE=RELEASE \
      -D CMAKE_INSTALL_PREFIX=/usr/local \
      -D OPENCV_EXTRA_MODULES_PATH=../../opencv_contrib/modules \
      -D ENABLE_PRECOMPILED_HEADERS=OFF \
      -D WITH_TBB=ON \
      -D WITH_V4L=ON \
      -D WITH_QT=ON \
      -D WITH_OPENGL=ON ..

# Compilar usando todos os núcleos disponíveis
NUM_CPUS=$(nproc)
echo "→ Compilando OpenCV com $NUM_CPUS núcleos..."
make -j"$NUM_CPUS"

# Instalar
echo "→ Instalando OpenCV..."
sudo make install
sudo ldconfig

echo "=== OpenCV instalado com sucesso! ==="
