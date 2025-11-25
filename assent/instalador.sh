#!/bin/bash
set -e
clear

echo "============================================"
echo "  Instalador Caixa-de-Areia - iniciando..."
echo "============================================"

LOG_DIR="$HOME/instalador-caixa"
LOG_FILE="$LOG_DIR/instalador-$(date +%Y%m%d-%H%M%S).log"
PKG_URL="https://github.com/kauanhup/caixade-areia/raw/main/assent/instalacao-caixa-de-areia.tar.gz"
PKG_FILE="$LOG_DIR/instalacao-caixa-de-areia.tar.gz"
EXTRACT_DIR="$HOME/instalacao-caixa-de-areia"

mkdir -p "$LOG_DIR"

echo "Log: $LOG_FILE"
exec > >(tee -a "$LOG_FILE") 2>&1

echo
echo "→ Checando conexão com a internet..."
ping -c 1 github.com >/dev/null 2>&1 || { echo "❌ Sem conexão com a internet."; exit 1; }
echo "OK"

echo
echo "→ Garantindo utilitários básicos (wget, tar)..."
sudo apt update -y >/dev/null 2>&1
sudo apt install -y wget tar >/dev/null 2>&1

echo
echo "→ Baixando pacote: $PKG_URL"
wget -q --show-progress -O "$PKG_FILE" "$PKG_URL"

echo "→ Extraindo em $EXTRACT_DIR ..."
mkdir -p "$EXTRACT_DIR"
tar -xzf "$PKG_FILE" -C "$EXTRACT_DIR"

cd "$EXTRACT_DIR"

echo "→ Definindo permissão de execução em *.sh"
chmod +x *.sh

echo
echo "Sequência de execução planejada:"
echo "  01) Instalar-Vrui.sh"
echo "  02) Instalar-Kinect.sh"
echo "  03) Instalar-SARndbox.sh"
echo "  04) Instalar Caixa-de-Areia (AppImage)"
echo
read -p "Deseja continuar e executar os scripts acima? (s/N): " resp
[[ "$resp" =~ ^[sS]$ ]] || { echo "Instalação cancelada."; exit 0; }

run_script() {
  local script="$1"
  echo
  echo "→ ==== Executando: $script ===="
  if [[ -f "$script" ]]; then
    bash "$script" || echo "⚠️  Aviso: erro ao executar $script — ignorando e continuando..."
  else
    echo "❌ Script $script não encontrado."
  fi
}

# Executa todos os scripts (mesmo que um falhe)
run_script "Instalar-Vrui.sh"
run_script "Instalar-Kinect.sh"
run_script "Instalar-SARndbox.sh"
run_script "adicionais.sh"

echo
echo "→ Instalando Caixa-de-Areia (AppImage)..."

DESKTOP_DIR=$(xdg-user-dir DESKTOP 2>/dev/null)
[[ -z "$DESKTOP_DIR" ]] && DESKTOP_DIR="$HOME/Desktop"

APPIMAGE_SRC="$EXTRACT_DIR/Caixade-Areia.AppImage"
APPIMAGE_DST="$DESKTOP_DIR/Caixade-Areia.AppImage"

if [[ -f "$APPIMAGE_SRC" ]]; then
  cp "$APPIMAGE_SRC" "$APPIMAGE_DST"
  chmod +x "$APPIMAGE_DST"
  echo "✓ AppImage movida para a Área de Trabalho"
else
  echo "❌ Caixade-Areia.AppImage não encontrada!"
fi

echo "→ Criando atalho .desktop..."

mkdir -p "$HOME/.local/share/applications"

# Ícone opcional — se existir, usa, senão ignora.
ICON_PATH="$EXTRACT_DIR/conf/icone.png"
[[ ! -f "$ICON_PATH" ]] && ICON_PATH=""

cat > "$HOME/.local/share/applications/caixa-de-areia.desktop" <<EOF
[Desktop Entry]
Name=Caixa de Areia
Exec=$APPIMAGE_DST
Icon=$ICON_PATH
Type=Application
Terminal=false
Categories=Education;Science;
EOF

chmod +x "$HOME/.local/share/applications/caixa-de-areia.desktop"

echo "✓ Atalho criado em ~/.local/share/applications/"
echo

echo "============================================"
echo "  Instalador concluído com sucesso!"
echo "============================================"
echo "Log salvo em: $LOG_FILE"

echo
echo "🧹 Limpando arquivos temporários..."
rm -rf "$EXTRACT_DIR" "$LOG_DIR"
echo "🧽 Pastas temporárias removidas com sucesso!"

echo
echo "🚀 Sistema pronto para uso!"
echo "============================================"

