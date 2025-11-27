#ifndef PALETTEMANAGER_H
#define PALETTEMANAGER_H

#include <QObject>
#include <QString>

class PaletteManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int selectedPalette READ selectedPalette WRITE setSelectedPalette NOTIFY selectedPaletteChanged)
    
public:
    explicit PaletteManager(QObject *parent = nullptr);
    
    int selectedPalette() const { return m_selectedPalette; }
    void setSelectedPalette(int palette);
    
    Q_INVOKABLE bool applyPalette(int paletteIndex);
    Q_INVOKABLE void loadConfiguration();
    
signals:
    void selectedPaletteChanged();
    void paletteApplied(bool success, const QString &message);
    
private:
    int m_selectedPalette;
    QString m_pastaBase;
    QString m_arquivoConfig;
    QString m_destinoCpt;
    
    bool copyFile(const QString &source, const QString &destination);
    void saveConfiguration(int palette);
};

#endif // PALETTEMANAGER_H
