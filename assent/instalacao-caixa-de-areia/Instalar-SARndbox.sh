#!/bin/bash

# --- Instalação do SARndbox 2.8 ---

# Entrar na pasta src
cd ~/src || exit 1

# Baixar o pacote oficial do SARndbox
echo "→ Baixando SARndbox-2.8..."
wget http://web.cs.ucdavis.edu/~okreylos/ResDev/SARndbox/SARndbox-2.8.tar.gz

# Descompactar
echo "→ Descompactando SARndbox-2.8..."
tar xfz SARndbox-2.8.tar.gz

# Entrar na pasta descompactada
cd SARndbox-2.8 || exit 1

# Compilar
echo "→ Compilando SARndbox-2.8..."
make

# Listar binários compilados
echo "→ Conteúdo da pasta ./bin após compilação:"
ls ./bin

# Limpeza do .tar.gz
echo "→ Limpando arquivo .tar.gz..."
if [ -f ~/src/SARndbox-2.8.tar.gz ]; then
    rm ~/src/SARndbox-2.8.tar.gz
    echo "→ Arquivo SARndbox-2.8.tar.gz removido."
else
    echo "→ Nenhum arquivo .tar.gz encontrado em ~/src, nada a limpar."
fi

echo "=== SARndbox-2.8 compilado com sucesso! Pasta SARndbox-2.8 mantida. ==="
