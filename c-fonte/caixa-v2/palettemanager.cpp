#include "palettemanager.h"
#include <QFile>
#include <QTextStream>
#include <QDir>
#include <QDebug>

PaletteManager::PaletteManager(QObject *parent)
    : QObject(parent)
    , m_selectedPalette(0)
{
    // 🔥 Configurar caminhos
    m_pastaBase = "/home/kauan/Caixade-Areia/resources/tabela_c/";
    m_arquivoConfig = "/home/kauan/Caixade-Areia/conf/config_paleta.txt";
    m_destinoCpt = "/home/kauan/src/SARndbox/etc/HeightColorMap.cpt";
    
    // Carrega configuração salva
    loadConfiguration();
}

void PaletteManager::setSelectedPalette(int palette)
{
    if (m_selectedPalette != palette) {
        m_selectedPalette = palette;
        emit selectedPaletteChanged();
    }
}

bool PaletteManager::applyPalette(int paletteIndex)
{
    qDebug() << "🎨 Aplicando paleta:" << paletteIndex;
    
    // 🔥 Caminho da origem (cor_1 a cor_6)
    QString paletaNumero = QString::number(paletteIndex + 1); // índice começa em 0
    QString origem = QString("%1cor_%2/HeightColorMap.cpt").arg(m_pastaBase).arg(paletaNumero);
    
    qDebug() << "📂 Origem:" << origem;
    qDebug() << "📂 Destino:" << m_destinoCpt;
    
    // Verifica se arquivo existe
    if (!QFile::exists(origem)) {
        qDebug() << "❌ Arquivo não encontrado:" << origem;
        emit paletteApplied(false, "Arquivo HeightColorMap.cpt não encontrado");
        return false;
    }
    
    // Remove destino se existir
    if (QFile::exists(m_destinoCpt)) {
        if (!QFile::remove(m_destinoCpt)) {
            qDebug() << "❌ Erro ao remover arquivo antigo";
            emit paletteApplied(false, "Erro ao remover arquivo antigo");
            return false;
        }
    }
    
    // Copia arquivo
    if (QFile::copy(origem, m_destinoCpt)) {
        qDebug() << "✅ Paleta aplicada com sucesso!";
        setSelectedPalette(paletteIndex);
        saveConfiguration(paletteIndex);
        emit paletteApplied(true, "Paleta aplicada com sucesso!");
        return true;
    } else {
        qDebug() << "❌ Erro ao copiar arquivo";
        emit paletteApplied(false, "Erro ao copiar arquivo");
        return false;
    }
}

void PaletteManager::saveConfiguration(int palette)
{
    QFile file(m_arquivoConfig);
    if (file.open(QIODevice::WriteOnly | QIODevice::Text)) {
        QTextStream out(&file);
        out << palette;
        file.close();
        qDebug() << "💾 Configuração salva:" << palette;
    } else {
        qDebug() << "❌ Erro ao salvar configuração";
    }
}

void PaletteManager::loadConfiguration()
{
    QFile file(m_arquivoConfig);
    if (file.exists() && file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        QTextStream in(&file);
        int palette = 0;
        in >> palette;
        
        if (palette >= 0 && palette < 6) {
            m_selectedPalette = palette;
        } else {
            m_selectedPalette = 0;
        }
        file.close();
        qDebug() << "📖 Configuração carregada:" << m_selectedPalette;
    } else {
        m_selectedPalette = 0;
        qDebug() << "ℹ️ Nenhuma configuração salva, usando padrão";
    }
}

