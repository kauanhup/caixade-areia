
# Projeto Caixa de Areia Interativa - Rio Branco (MT)

## 📖 Sobre o Projeto

As informações completas sobre este projeto podem ser encontradas em nosso blog: [clique aqui!](https://caixade-areia.com)

### Este Projeto utiliza como base: ___The Augmented Reality Sandbox___

![KeckCAVESLogo](https://raw.githubusercontent.com/lifefurb/caixaeagua/master/Imagens/KeckCAVESLogoSideways.png)

O Augmented Reality Sandbox foi desenvolvido pelo Centro W.M. Keck para Visualização Ativa em Ciências da Terra da UC Davis (KeckCAVES, http://www.keckcaves.org), com apoio da National Science Foundation sob a concessão nº DRL 1114663.

For more information, please visit https://arsandbox.ucdavis.edu.

## 💿 Requisitos do Sistema

### Sistema Operacional Base

Este projeto requer o **Linux Mint 19.3 Cinnamon 64-bit** como sistema operacional base.

**Download da ISO (1.9GB):**

1. Acesse o mirror da UNESP: [https://mirror.unesp.br/linuxmint/iso/stable/19.3/](https://mirror.unesp.br/linuxmint/iso/stable/19.3/)

2. Baixe o arquivo: **linuxmint-19.3-cinnamon-64bit.iso**
   - Tamanho: 1.9GB
   - Data: 2019-12-13

## 🚀 Instalação

### 1. Instalar o Linux Mint

1. Grave a ISO em um pendrive bootável
2. Instale o Linux Mint 19.3 no computador

### 2. Baixar os arquivos do projeto

Faça o download do arquivo de instalação [aqui](https://github.com/kauanhup/caixade-areia/raw/main/assent/instalacao-caixa-de-areia.tar.gz).

### 3. Preparar os arquivos

1. Descompacte o arquivo para a **pasta do seu usuário** (Pasta pessoal).

2. Entre na pasta **instalacao-caixa-de-areia**.

3. Clique com o botão direito do mouse em uma **"área branca"** sem selecionar nenhum item.

4. No menu de contexto selecione a opção **"Abrir no terminal"**.

### 4. Executar os scripts de instalação

Execute os comandos abaixo na ordem indicada:

#### 4.1. Instalar o Vrui
```bash
./Instalar-Vrui.sh
```
Aguarde a conclusão da instalação antes de prosseguir.

#### 4.2. Instalar o Kinect
```bash
./Instalar-Kinect.sh
```
Este script instala os drivers e bibliotecas necessários para o sensor Kinect.

#### 4.3. Instalar o SARndbox
```bash
./Instalar-SARndbox.sh
```
Instala o software Augmented Reality Sandbox.

#### 4.4. Instalar o Caixade-Areia
```bash
./Instalar-caixade-areia.sh
```
Instala as customizações e recursos específicos do projeto brasileiro.

### 5. Configurar o atalho

1. Copie o arquivo **Caixa-e-Agua.sh** para a **área de trabalho**.

2. Dê permissão de execução ao arquivo:
```bash
chmod +x ~/Área\ de\ Trabalho/Caixa-de-areia.sh
```

### 6. Executar o programa

Execute o arquivo **Caixa-de-areia.sh** na área de trabalho clicando duas vezes sobre ele.

## 📚 Documentação Adicional

- [Blog do Projeto](https://caixade-areia.com)
- [Blog Caixa e-Água](https://caixae-agua.blogspot.com/)
- [Documentação oficial do AR Sandbox](https://arsandbox.ucdavis.edu)
- [GitHub do projeto original](https://github.com/KeckCAVES/SARndbox)

## 🤝 Contribuindo

Este é um projeto de código aberto! Sinta-se livre para modificar, adaptar e melhorar conforme suas necessidades.

## 📄 Licença

Este projeto utiliza componentes do AR Sandbox original, desenvolvido pela UC Davis sob Grant No. DRL 1114663 da National Science Foundation.

---

**Modificado para fins educacionais - Projeto Caixa de Areia Interativa**  
Rio Branco, Mato Grosso, Brasil

