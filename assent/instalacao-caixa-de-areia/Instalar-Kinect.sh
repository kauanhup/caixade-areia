#!/bin/bash

# --- Instalação do Kinect 3.10 ---

# Entrar na pasta src
cd ~/src || exit 1

# Baixar o pacote oficial do Kinect
echo "→ Baixando Kinect-3.10..."
wget http://web.cs.ucdavis.edu/~okreylos/ResDev/Kinect/Kinect-3.10.tar.gz

# Descompactar
echo "→ Descompactando Kinect-3.10..."
tar xfz Kinect-3.10.tar.gz

# Entrar na pasta descompactada
cd Kinect-3.10 || exit 1

# Compilar
echo "→ Compilando Kinect-3.10..."
make

# Instalar
echo "→ Instalando Kinect-3.10..."
sudo make install
sudo make installudevrules

# Listar binários instalados
echo "→ Conteúdo de /usr/local/bin após instalação:"
ls /usr/local/bin

# Limpeza do .tar.gz
echo "→ Limpando arquivo .tar.gz..."
if [ -f ~/src/Kinect-3.10.tar.gz ]; then
    rm ~/src/Kinect-3.10.tar.gz
    echo "→ Arquivo Kinect-3.10.tar.gz removido."
else
    echo "→ Nenhum arquivo .tar.gz encontrado em ~/src, nada a limpar."
fi

echo "=== Kinect instalado com sucesso! Pasta Kinect-3.10 mantida. ==="
