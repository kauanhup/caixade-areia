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
echo "  01) Instalar-Opencv.sh"
echo "  02) Instalar-Vrui.sh"
echo "  03) Instalar-Kinect.sh"
echo "  04) Instalar-SARndbox.sh"
echo "  05) instalar-caixade-areia.sh"
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
run_script "Instalar-Opencv.sh"
run_script "Instalar-Vrui.sh"
run_script "Instalar-Kinect.sh"
run_script "Instalar-SARndbox.sh"
run_script "instalar-caixade-areia.sh"

echo
echo "✅ Instalação concluída (com ou sem avisos)."
echo "------------------------------------------"
echo "Logs salvos em: $LOG_FILE"
echo "------------------------------------------"

echo "🧹 Limpando arquivos temporários..."
rm -rf "$EXTRACT_DIR" "$LOG_DIR"
echo "🧽 Pastas temporárias removidas com sucesso!"

echo
echo "🚀 Sistema pronto para uso!"
echo "============================================"

