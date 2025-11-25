#!/bin/bash
# ===========================================================
#  Instalar-Vrui.sh
#  Instalação limpa e oficial do Vrui (Oliver Kreylos)
# ===========================================================

echo -e "\e[1;32m=== Iniciando instalação oficial do Vrui ===\e[0m"

# Voltar uma pasta (para /home/projeto)
cd .. || exit 1

# Criar diretório src se não existir
echo -e "\e[1;34m→ Criando diretório ~/src\e[0m"
mkdir -p "$HOME/src"

# Baixar script oficial de build do Vrui
echo -e "\e[1;34m→ Baixando instalador oficial Build-Ubuntu.sh\e[0m"
wget -q http://web.cs.ucdavis.edu/~okreylos/ResDev/Vrui/Build-Ubuntu.sh -O "$HOME/Build-Ubuntu.sh"

# Dar permissão de execução
chmod +x "$HOME/Build-Ubuntu.sh"

# Rodar o instalador
echo -e "\e[1;33m→ Instalando Vrui, isso pode demorar um pouco...\e[0m"
bash "$HOME/Build-Ubuntu.sh"

# Verificar se deu certo
if [ $? -eq 0 ]; then
    echo -e "\e[1;32m=== Vrui instalado com sucesso! ===\e[0m"
else
    echo -e "\e[1;31m✖ Erro durante a instalação do Vrui. Verifique os logs acima.\e[0m"
    exit 1
fi

# Remover o instalador temporário
echo -e "\e[1;34m→ Limpando arquivos temporários...\e[0m"
rm -f "$HOME/Build-Ubuntu.sh"

echo -e "\e[1;32m=== Instalação concluída. Vrui pronto para uso! ===\e[0m"
