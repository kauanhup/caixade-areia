#include "aula_1.h"
#include "ui_aula_1.h"
#include <QFile>
#include <QTextStream>
#include <QMessageBox>
#include <QPixmap>
#include <QDebug>

Aula_1::Aula_1(QWidget *parent) :
    QWidget(parent),
    ui(new Ui::Aula_1)
{
    ui->setupUi(this);

    pastaBase = "/home/projeto/Caixade-Areia/resources/tabela_c/";
    arquivoConfig = "/home/projeto/Caixade-Areia/conf/config_c.txt";

    // conecta os botões aos slots de seleção
    for (int i = 1; i <= 8; ++i) {
        QPushButton *btn = findChild<QPushButton*>(QString("btn_modelo_%1").arg(i));
        if (btn) {
            connect(btn, &QPushButton::clicked, [this, i](){
                selecionarModelo(i);
            });
        }
    }

    // botão salvar
    connect(ui->btn_validar, &QPushButton::clicked, this, &Aula_1::salvarAlteracoes);

    carregarConfiguracao();        // carrega o modelo salvo
    selecionarModelo(modeloSelecionado); // exibe no meio
    atualizarBotoes();             // exibe as imagens laterais preenchendo os botões
}

Aula_1::~Aula_1()
{
    delete ui;
}

void Aula_1::selecionarModelo(int num)
{
    modeloSelecionado = num;
    QLabel *labelMeio = ui->modelo;
    QString caminho = QString("%1cor_%2/modelo_%2.png").arg(pastaBase).arg(num);
    QPixmap pix(caminho);
    if (pix.isNull()) {
        qDebug() << "Falha ao carregar imagem do meio:" << caminho;
        labelMeio->clear();
    } else {
        labelMeio->setPixmap(pix.scaled(labelMeio->size(), Qt::KeepAspectRatio, Qt::SmoothTransformation));
    }
    atualizarBotoes();
}

void Aula_1::atualizarBotoes()
{
    // Atualiza as 8 imagens laterais
    for (int i = 1; i <= 8; ++i) {
        QPushButton *btn = findChild<QPushButton*>(QString("btn_modelo_%1").arg(i));
        if (btn) {
            QString caminho = QString("%1cor_%2/modelo_%2.png").arg(pastaBase).arg(i);
            QPixmap pix(caminho);
            if (!pix.isNull()) {
                pix = pix.scaled(btn->size(), Qt::KeepAspectRatioByExpanding, Qt::SmoothTransformation);
                btn->setIcon(QIcon(pix));
                btn->setIconSize(btn->size());
            } else {
                btn->setIcon(QIcon());
            }
        }
    }
}

void Aula_1::salvarAlteracoes()
{
    QFile file(arquivoConfig);
    if (file.open(QIODevice::WriteOnly | QIODevice::Text)) {
        QTextStream out(&file);
        out << modeloSelecionado; // salva apenas o modelo selecionado
        file.close();

        // copia o arquivo HeightColorMap.cpt para a pasta do modelo
        QString origem = QString("%1cor_%2/HeightColorMap.cpt").arg(pastaBase).arg(modeloSelecionado);
        QString destino = "/home/projeto/src/SARndbox-2.8/etc/SARndbox-2.8/HeightColorMap.cpt";

        if (!QFile::exists(origem)) {
            QMessageBox::warning(this, "Salvar", "HeightColorMap.cpt não encontrado no modelo selecionado");
            return;
        }

        if (QFile::exists(destino))
            QFile::remove(destino);

        if (QFile::copy(origem, destino)) {
            QMessageBox::information(this, "Salvar", "Salvo com sucesso!");
        } else {
            QMessageBox::warning(this, "Salvar", "Falha ao copiar o HeightColorMap.cpt");
        }
    } else {
        QMessageBox::warning(this, "Salvar", "Não foi possível salvar a configuração");
    }
}

void Aula_1::carregarConfiguracao()
{
    QFile file(arquivoConfig);
    if (file.exists() && file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        QTextStream in(&file);
        int modelo = 1;
        in >> modelo;
        if (modelo >=1 && modelo <=8)
            modeloSelecionado = modelo;
        else
            modeloSelecionado = 1;
        file.close();
    } else {
        modeloSelecionado = 1; // default se arquivo não existe
    }
}

void Aula_1::keyPressEvent(QKeyEvent *event)
{
    if(event->key() == Qt::Key_Escape)
        close();
    else
        QWidget::keyPressEvent(event);
}

void Aula_1::resizeEvent(QResizeEvent *event)
{
    QWidget::resizeEvent(event);
    atualizarBotoes(); // reajusta os ícones laterais
    // reajusta imagem do meio
    if (!ui->modelo->pixmap()->isNull())
        ui->modelo->setPixmap(ui->modelo->pixmap()->scaled(ui->modelo->size(), Qt::KeepAspectRatio, Qt::SmoothTransformation));
}

