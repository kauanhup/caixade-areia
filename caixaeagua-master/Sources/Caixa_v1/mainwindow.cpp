#include "mainwindow.h"
#include "ui_mainwindow.h"

#include <QKeyEvent>
#include <QDesktopServices>
#include <QProcess>
#include <QDir>
#include <QUrl>
#include <iostream>
#include <fstream>
#include <sstream>

using namespace std;

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent), ui(new Ui::MainWindow)
{
    ui->setupUi(this);

    aula2 = new Aula_2;
}

MainWindow::~MainWindow()
{
    delete ui;
}

void MainWindow::keyPressEvent(QKeyEvent *e)
{
    const int tecla = int(e->key());

    // 16777216 = ESC
    if (tecla == 16777216)
    {
        QApplication::quit();
    }
}

// ===============================
// ======== AULA 1 ===============
// ===============================
void MainWindow::on_btn_aula_1_clicked()
{
    toggleOpcoes(false);

    // Abre o Sandbox em fullscreen
    QProcess::startDetached("bash", QStringList() << "-c" << "cd ~/src/SARndbox-2.8 && gnome-terminal --fullscreen -- ./bin/SARndbox -uhm -fpv");

    toggleOpcoes(true);
}

// ===============================
// ======== AULA 2 ===============
// ===============================
void MainWindow::on_btn_aula_2_clicked()
{
    toggleOpcoes(false);

    // Abre a interface da aula 2 em fullscreen
    aula2->showFullScreen();

    toggleOpcoes(true);
}

// ===============================
// ======== CALIBRAR PROJETOR ====
// ===============================
void MainWindow::on_actionProjetor_triggered()
{
    toggleOpcoes(false);

    // Abre o calibrador do projetor em fullscreen
    QProcess::startDetached("bash", QStringList() << "-c" << "cd ~/src/SARndbox-2.8 && gnome-terminal --fullscreen -- ./bin/CalibrateProjector");

    toggleOpcoes(true);
}

// ===============================
// ======== CALIBRAR KINECT ======
// ===============================
void MainWindow::on_actionKinect_triggered()
{
    toggleOpcoes(false);

    // Executa o RawKinectViewer e captura a saída
    QProcess processo;
    processo.setProgram("bash");
    processo.setArguments(QStringList() << "-c"
                                        << "cd ~/src/SARndbox-2.8 && ./bin/RawKinectViewer -compress 0");
    processo.start();
    processo.waitForFinished(-1);

    QByteArray saida = processo.readAllStandardOutput();
    QString textoOriginal(saida);

    // Substitui "=" por ","
    textoOriginal.replace("=", ",");

    // Caminho do BoxLayout.txt
    QString caminhoBoxLayout = QDir::homePath() + "/src/SARndbox-2.8/etc/SARndbox-2.8/BoxLayout.txt";

    // Salva os dados no arquivo
    ofstream arquivo(caminhoBoxLayout.toStdString());
    arquivo << textoOriginal.toStdString();
    arquivo.close();

    // Abre o arquivo no xed em fullscreen
    QString comandoAbrir = "gnome-terminal --fullscreen -- bash -c 'xed " + caminhoBoxLayout + "; exec bash'";
    system(comandoAbrir.toStdString().c_str());

    toggleOpcoes(true);
}

// ===============================
// ======== TOGGLE OPCOES ========
// ===============================
void MainWindow::toggleOpcoes(bool ativar)
{
    ui->btn_aula_1->setEnabled(ativar);
    ui->btn_aula_2->setEnabled(ativar);

    ui->actionKinect->setEnabled(ativar);
    ui->actionProjetor->setEnabled(ativar);
}

