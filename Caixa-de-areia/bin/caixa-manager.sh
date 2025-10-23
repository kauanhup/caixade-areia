#!/usr/bin/env bash
set -euo pipefail

# Caixa de Areia Manager - orquestra Vrui, Kinect e SARndbox
# Uso: ./caixa-manager.sh

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

VRUI_BIN="/workspace/src/Vrui-8.0-002/bin"
KINECT_BIN="/workspace/src/Kinect-3.10/bin"
SARNDBOX_BIN="/workspace/src/SARndbox-2.8/bin"

VRUI_CFG_LOCAL="${SCRIPT_DIR}/Vrui.cfg"

VRDEVICE_DAEMON_PID_FILE="${SCRIPT_DIR}/.vrdevice_daemon.pid"

# --- Helpers ---
color() { local c="$1"; shift; echo -e "\033[${c}m$*\033[0m"; }
info() { color 36 "[INFO] $*"; }
warn() { color 33 "[WARN] $*"; }
err()  { color 31 "[ERRO] $*"; }

essential_file() {
  local f="$1"
  if [[ ! -x "$f" ]]; then
    err "Arquivo executável não encontrado: $f"
    return 1
  fi
}

pause_read() { read -r -p "Pressione ENTER para continuar..." _; }

# --- Checks ---
check_environment() {
  info "Verificando binários essenciais..."
  essential_file "${VRUI_BIN}/RoomSetup" || return 1
  essential_file "${KINECT_BIN}/KinectUtil" || return 1
  essential_file "${KINECT_BIN}/RawKinectViewer" || return 1
  essential_file "${SARNDBOX_BIN}/CalibrateProjector" || return 1
  essential_file "${SARNDBOX_BIN}/SARndbox" || return 1
  info "OK"
  if [[ -f "${VRUI_CFG_LOCAL}" ]]; then
    info "Detectado Vrui.cfg local: ${VRUI_CFG_LOCAL} (usado automaticamente pelo Vrui, se aplicável)"
  fi
}

# --- Actions ---
list_kinects() {
  info "Listando dispositivos Kinect..."
  "${KINECT_BIN}/KinectUtil" list || true
  pause_read
}

run_rawkinectviewer() {
  info "Abrindo RawKinectViewer (feche a janela para voltar ao menu)..."
  "${KINECT_BIN}/RawKinectViewer" || true
}

calibrate_projector() {
  local width height
  echo "Resolução do projetor (padrão 1024x768).";
  read -r -p "Largura [1024]: " width || true; width=${width:-1024}
  read -r -p "Altura  [768]:  " height || true; height=${height:-768}
  info "Iniciando CalibrateProjector em ${width}x${height} (use F11 p/ tela cheia)..."
  "${SARNDBOX_BIN}/CalibrateProjector" -s "${width}" "${height}" || true
}

start_vrdeviced() {
  if [[ -f "${VRDEVICE_DAEMON_PID_FILE}" ]] && kill -0 "$(cat "${VRDEVICE_DAEMON_PID_FILE}")" 2>/dev/null; then
    warn "VRDeviceDaemon já está em execução (PID $(cat "${VRDEVICE_DAEMON_PID_FILE}"))"
    return 0
  fi
  if [[ ! -x "${VRUI_BIN}/VRDeviceDaemon" ]]; then
    warn "VRDeviceDaemon não encontrado. Pule esta etapa se não usar Vive."
    return 0
  fi
  info "Iniciando VRDeviceDaemon (Vive). Para encerrar, use a opção do menu.";
  ("${VRUI_BIN}/VRDeviceDaemon" >/dev/null 2>&1 & echo $! > "${VRDEVICE_DAEMON_PID_FILE}") || true
  sleep 0.5
  info "VRDeviceDaemon iniciado (PID $(cat "${VRDEVICE_DAEMON_PID_FILE}"))"
}

stop_vrdeviced() {
  if [[ -f "${VRDEVICE_DAEMON_PID_FILE}" ]]; then
    local pid; pid=$(cat "${VRDEVICE_DAEMON_PID_FILE}")
    if kill -0 "$pid" 2>/dev/null; then
      info "Encerrando VRDeviceDaemon (PID ${pid})..."
      kill "$pid" || true
      rm -f "${VRDEVICE_DAEMON_PID_FILE}"
      info "Encerrado."
    else
      rm -f "${VRDEVICE_DAEMON_PID_FILE}"
      warn "PID não ativo, removendo arquivo de PID."
    fi
  else
    warn "VRDeviceDaemon não está em execução."
  fi
}

run_sarndbox() {
  local use_height_map="y" use_fixed_proj="y"
  local use_water_sim="n" water_w="200" water_h="150" extra=""

  read -r -p "Usar mapa de altura (-uhm)? [Y/n]: " use_height_map || true
  read -r -p "Fixar visão do projetor (-fpv)? [Y/n]: " use_fixed_proj || true
  read -r -p "Ativar simulação de água? (requer GPU forte) [y/N]: " use_water_sim || true

  [[ "${use_height_map,,}" != "n" ]] && extra+=" -uhm"
  [[ "${use_fixed_proj,,}" != "n" ]] && extra+=" -fpv"

  if [[ "${use_water_sim,,}" == "y" ]]; then
    read -r -p "Resolução água - largura [200]: " water_w || true; water_w=${water_w:-200}
    read -r -p "Resolução água - altura  [150]: " water_h || true; water_h=${water_h:-150}
    extra+=" -wts ${water_w} ${water_h}"
  else
    extra+=" -ws 0.0 0"
  fi

  info "Iniciando SARndbox com opções:${extra}"
  info "Dica: Use F11 para tela cheia no projetor."
  "${SARNDBOX_BIN}/SARndbox" ${extra}
}

install_udev_rules() {
  info "Instalando regras udev para Kinect (requer sudo)..."
  (cd "/workspace/src/Kinect-3.10" && sudo make installudevrules)
  sudo udevadm control --reload
  sudo udevadm trigger --action=change
  info "Regras aplicadas. Replugue o Kinect se necessário."
  pause_read
}

show_paths() {
  echo "\nCaminhos atuais:";
  echo "  VRUI_BIN:     ${VRUI_BIN}"
  echo "  KINECT_BIN:   ${KINECT_BIN}"
  echo "  SARNDBOX_BIN: ${SARNDBOX_BIN}"
  echo "  Vrui.cfg:     ${VRUI_CFG_LOCAL} (se existir)"
  pause_read
}

main_menu() {
  while true; do
    clear
    echo "$(color 35 '=== Caixa de Areia - Manager ===')"
    echo "1) Listar dispositivos Kinect"
    echo "2) Abrir RawKinectViewer (calibração do Kinect)"
    echo "3) Calibrar Projetor (CalibrateProjector)"
    echo "4) Iniciar SARndbox"
    echo "5) Iniciar VRDeviceDaemon (Vive)"
    echo "6) Parar VRDeviceDaemon (Vive)"
    echo "7) Instalar regras udev do Kinect (sudo)"
    echo "8) Mostrar caminhos"
    echo "9) Sair"
    echo
    read -r -p "Escolha uma opção [1-9]: " opt || true
    case "${opt}" in
      1) list_kinects ;;
      2) run_rawkinectviewer ;;
      3) calibrate_projector ;;
      4) run_sarndbox ;;
      5) start_vrdeviced ; pause_read ;;
      6) stop_vrdeviced ; pause_read ;;
      7) install_udev_rules ;;
      8) show_paths ;;
      9) echo "Saindo..."; exit 0 ;;
      *) warn "Opção inválida"; sleep 1 ;;
    esac
  done
}

# --- Entry point ---
check_environment || { err "Requisitos não encontrados. Ajuste os caminhos e tente novamente."; exit 1; }
main_menu
