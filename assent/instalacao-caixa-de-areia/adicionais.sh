#!/bin/bash

# Script de configuração inicial do Vrui para SARndbox
# Cria estrutura de pastas e arquivos de configuração básicos
# Autor: Sistema de Gerenciamento SARndbox
# Data: 2024

echo "=========================================="
echo "  Setup de Configuração Vrui - SARndbox  "
echo "=========================================="
echo ""

# Diretório de configuração
CONFIG_DIR="$HOME/.config/Vrui-8.0/Applications"
CALIBRATE_CFG="$CONFIG_DIR/CalibrateProjector.cfg"
SANDBOX_CFG="$CONFIG_DIR/SARndbox.cfg"

# Verifica se o diretório existe
if [ -d "$CONFIG_DIR" ]; then
    echo "✅ Diretório já existe: $CONFIG_DIR"
else
    echo "📁 Criando diretório: $CONFIG_DIR"
    mkdir -p "$CONFIG_DIR"
    if [ $? -eq 0 ]; then
        echo "✅ Diretório criado com sucesso!"
    else
        echo "❌ Erro ao criar diretório!"
        exit 1
    fi
fi

echo ""
echo "=========================================="
echo "  Configurando CalibrateProjector.cfg    "
echo "=========================================="

# Verifica se CalibrateProjector.cfg existe
if [ -f "$CALIBRATE_CFG" ]; then
    echo "⚠️  Arquivo já existe: $CALIBRATE_CFG"
    echo "📝 Criando backup..."
    cp "$CALIBRATE_CFG" "$CALIBRATE_CFG.backup.$(date +%Y%m%d_%H%M%S)"
    echo "✅ Backup criado!"
fi

# Cria CalibrateProjector.cfg
echo "📝 Criando/Atualizando CalibrateProjector.cfg..."
cat > "$CALIBRATE_CFG" << 'EOF'
section Vrui
    section Desktop
        section Window
            # Force the application's window to full-screen mode:
            windowFullscreen true
        endsection
        
        section Tools
            section DefaultTools
                # Bind a tie point capture tool to the "1" and "2" keys:
                section CalibrationTool
                    toolClass CaptureTool
                    bindings ((Mouse, 1, 2))
                endsection
            endsection
        endsection
    endsection
endsection
EOF

if [ $? -eq 0 ]; then
    echo "✅ CalibrateProjector.cfg criado/atualizado!"
else
    echo "❌ Erro ao criar CalibrateProjector.cfg!"
    exit 1
fi

echo ""
echo "=========================================="
echo "  Configurando SARndbox.cfg              "
echo "=========================================="

# Verifica se SARndbox.cfg existe
if [ -f "$SANDBOX_CFG" ]; then
    echo "⚠️  Arquivo já existe: $SANDBOX_CFG"
    echo "📝 Criando backup..."
    cp "$SANDBOX_CFG" "$SANDBOX_CFG.backup.$(date +%Y%m%d_%H%M%S)"
    echo "✅ Backup criado!"
fi

# Cria SARndbox.cfg (básico, sem Window2)
echo "📝 Criando/Atualizando SARndbox.cfg..."
cat > "$SANDBOX_CFG" << 'EOF'
section Vrui
    section Desktop
        # Disable the screen saver:
        inhibitScreenSaver true
        
        section MouseAdapter
            # Hide the mouse cursor after 5 seconds of inactivity:
            mouseIdleTimeout 5.0
        endsection
        
        section Window
            # Force the application's window to full-screen mode:
            windowFullscreen true
        endsection
        
        section Tools
            section DefaultTools
                # Bind a global rain/dry tool to the "1" and "2" keys:
                section WaterTool
                    toolClass GlobalWaterTool
                    bindings ((Mouse, 1, 2))
                endsection
            endsection
        endsection
    endsection
endsection
EOF

if [ $? -eq 0 ]; then
    echo "✅ SARndbox.cfg criado/atualizado!"
else
    echo "❌ Erro ao criar SARndbox.cfg!"
    exit 1
fi

echo ""
echo "=========================================="
echo "  Resumo da Instalação                   "
echo "=========================================="
echo ""
echo "📂 Diretório: $CONFIG_DIR"
echo "📄 CalibrateProjector.cfg: ✅"
echo "📄 SARndbox.cfg: ✅ (configuração básica)"
echo ""
echo "⚠️  IMPORTANTE:"
echo "   - Para configurar segunda tela (modo 3D),"
echo "     use o aplicativo Qt de gerenciamento"
echo "   - O app Qt detectará displays e modificará"
echo "     automaticamente o SARndbox.cfg"
echo ""
echo "🎮 Modo 2D: ./bin/SARndbox -uhm -fpv"
echo "🎮 Modo 3D: ./bin/SARndbox -uhm -fpv -wi 1 -rws"
echo ""
echo "=========================================="
echo "  ✅ Configuração concluída com sucesso!  "
echo "=========================================="
