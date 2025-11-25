#!/bin/bash

echo "🔍 Verificando dependências básicas..."

# Função auxiliar pra verificar e instalar pacotes
check_and_install() {
  if ! dpkg -s "$1" &>/dev/null; then
    echo "📦 Instalando dependência: $1..."
    sudo apt-get install -y "$1"
  else
    echo "$1 já está instalado."
  fi
}

# Verificações
check_and_install make
check_and_install cmake
check_and_install g++
check_and_install build-essential
check_and_install xdg-user-dirs

echo "📦 Extraindo pacote do projeto Caixa-de-Areia..."

# Remove pasta antiga se existir
rm -rf "$HOME/Caixade-Areia"
tar -xzf Caixade-Areia.tar.gz -C "$HOME/"

echo "🧱 Compilando módulo Compara_Imagens..."

BUILD_DIR="$HOME/Caixade-Areia/sources/Compara_Imagens/build"
mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR" || { echo "❌ Erro ao acessar diretório build"; exit 1; }

# Compilar com CMake
cmake ..
make -j$(nproc)

# Verifica se o executável foi gerado
EXEC="$BUILD_DIR/ComparaImagens"
if [ -f "$EXEC" ]; then
  echo "📁 Movendo executável compilado..."
  sudo mkdir -p /usr/local/bin/caixa-de-areia
  sudo cp "$EXEC" /usr/local/bin/caixa-de-areia/
else
  echo "⚠️ Aviso: o executável ComparaImagens não foi gerado."
fi

echo "🔓 Ajustando permissões..."
sudo chmod +x /usr/local/bin/caixa-de-areia/ComparaImagens 2>/dev/null || true

echo "🖥️ Movendo script principal para a Área de Trabalho..."

# Detecta automaticamente a Área de Trabalho (compatível com qualquer idioma)
DESKTOP_PATH=$(xdg-user-dir DESKTOP 2>/dev/null)

# Se não encontrar, usa fallback
if [ -z "$DESKTOP_PATH" ] || [ ! -d "$DESKTOP_PATH" ]; then
  DESKTOP_PATH="$HOME/Desktop"
  mkdir -p "$DESKTOP_PATH"
fi

SCRIPT_ORIGINAL="$HOME/instalacao-caixa-de-areia/Caixa-de-areia.sh"

if [ -f "$SCRIPT_ORIGINAL" ]; then
  cp "$SCRIPT_ORIGINAL" "$DESKTOP_PATH/"
  chmod +x "$DESKTOP_PATH/Caixa-de-areia.sh"
  echo "✅ Script movido para: $DESKTOP_PATH"
else
  echo "⚠️ Aviso: o arquivo Caixa-de-areia.sh não foi encontrado em $SCRIPT_ORIGINAL"
fi

echo "🎉 Instalação concluída com sucesso!" olha esse meu script antigo... eu queria por nele a parte de configurar o .descktop e tbm ao ennves de ele copiar o script pra area de trabalho ele copia o executavel projeto@projeto-2025:~/Caixade-Areia/conf$ ls
caixa-de-areia.desktop	config_paleta.txt lprojeto@projeto-2025:~/Caixade-Areia/bin$ ls
caixa-de-areia
projeto@projeto-2025:~/Caixade-Areia/bin$ projeto@projeto-2025:~/Caixade-Areia/conf$ 
