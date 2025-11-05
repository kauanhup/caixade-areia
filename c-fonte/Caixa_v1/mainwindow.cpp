#include "mainwindow.h"
#include "ui_mainwindow.h"
#include <QKeyEvent>
#include <QDesktopServices>
#include <QProcess>
#include <QUrl>
#include <QDir>
#include <QFile>
#include <QThread>

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent), ui(new Ui::MainWindow)
{
    ui->setupUi(this);
    // Inicializa aulas como janelas independentes
    aula1 = new Aula_1(nullptr); // nullptr = janela independente
    aula3 = new Aula_3(nullptr);
}

MainWindow::~MainWindow()
{
    delete ui;
    delete aula1;
    delete aula3;
}

void MainWindow::keyPressEvent(QKeyEvent *e)
{
    if (e->key() == Qt::Key_Escape)
        QApplication::quit();
}

// ===============================
// ======== ABRIR CORES / AULA 1
// ===============================
void MainWindow::on_btn_aula_1_clicked()
{
    toggleOpcoes(false);
    aula1->show(); // ABRE NO TAMANHO NORMAL, não fullscreen
    toggleOpcoes(true);
}

// ===============================
// ======== ABRIR SANDBOX SEM 3D / AULA 2
// ===============================
void MainWindow::on_btn_aula_2_clicked()
{
    toggleOpcoes(false);
    
    // Abre o SARndbox com visualização normal (sem 3D navegável)
    QProcess::startDetached("bash", QStringList() << "-c"
        << "cd ~/src/SARndbox-2.8 && ./bin/SARndbox -uhm -fpv &");
    
    toggleOpcoes(true);
}

// ===============================
// ======== ABRIR BACIAS / AULA 3
// ===============================
void MainWindow::on_btn_aula_3_clicked()
{
    toggleOpcoes(false);
    aula3->showFullScreen(); // Tela cheia, sem branco
    toggleOpcoes(true);
}

// ===============================
// ======== ABRIR SANDBOX COM 3D / AULA 4
// ===============================
void MainWindow::on_btn_aula_4_clicked()
{
    toggleOpcoes(false);
    
    // Ativa as 2 telas (notebook + projetor)
    system("xrandr --output eDP-1-1 --auto --primary --output HDMI-0 --auto --right-of eDP-1-1");
    
    // Pequeno delay para as telas ativarem
    QThread::msleep(500);
    
    // Abre o SARndbox com visualização 3D navegável
    QProcess::startDetached("bash", QStringList() << "-c"
        << "cd ~/src/SARndbox-2.8 && ./bin/SARndbox -uhm -fpv -wi 1 -rws &");
    
    toggleOpcoes(true);
}

// ===============================
// ======== ABRIR SANDBOX COM PARÂMETROS CUSTOMIZADOS / AULA 5
// ===============================
void MainWindow::on_btn_aula_5_clicked()
{
    toggleOpcoes(false);
    
    // Abre o SARndbox com parâmetros específicos
    QProcess::startDetached("bash", QStringList() << "-c"
        << "cd ~/src/SARndbox-2.8 && ./bin/SARndbox -uhm -fpv -wo 20.0 -rs 0.1 -evr -0.002 &");
    
    toggleOpcoes(true);
}

// ===============================
// ======== MENU SITE CAIXADE-AREIA
// ===============================
void MainWindow::on_actionSite_Caixade_areia_triggered()
{
    QDesktopServices::openUrl(QUrl("https://caixade-areia.com/"));
}

// ===============================
// ======== MENU CAIXAE-AGUA
// ===============================
void MainWindow::on_actionCaixae_Agua_triggered()
{
    QDesktopServices::openUrl(QUrl("https://caixae-agua.blogspot.com/"));
}

// ===============================
// ======== MENU SANDBOX (UC DAVIS)
// ===============================
void MainWindow::on_actionSandbox_UC_Davis_triggered()
{
    QDesktopServices::openUrl(QUrl("https://web.cs.ucdavis.edu/~okreylos/ResDev/SARndbox/index.html"));
}

// ===============================
// ======== CALIBRAR PROJETOR
// ===============================
void MainWindow::on_actionProjetor_triggered()
{
    toggleOpcoes(false);
    QProcess::startDetached("bash", QStringList() << "-c"
        << "cd ~/src/SARndbox-2.8/bin && ./CalibrateProjector");
    toggleOpcoes(true);
}

// ===============================
// ======== CALIBRAR KINECT
// ===============================
void MainWindow::on_actionKinect_triggered()
{
    toggleOpcoes(false);
    
    QProcess processo;
    processo.setProgram("bash");
    processo.setArguments(QStringList() << "-c"
        << "cd ~/src/SARndbox-2.8/bin && ./RawKinectViewer -compress 0");
    
    processo.start();
    processo.waitForFinished(-1);
    
    QByteArray saida = processo.readAllStandardOutput();
    QString textoOriginal(saida);
    textoOriginal.replace("=", ",");
    
    QString caminhoBoxLayout = QDir::homePath() + "/src/SARndbox-2.8/etc/SARndbox-2.8/BoxLayout.txt";
    QFile arquivo(caminhoBoxLayout);
    
    if (arquivo.open(QIODevice::WriteOnly | QIODevice::Text)) {
        arquivo.write(textoOriginal.toUtf8());
        arquivo.close();
    }
    
    QString comandoAbrir = "gnome-terminal --fullscreen -- bash -c 'xed " + caminhoBoxLayout + "; exec bash'";
    system(comandoAbrir.toStdString().c_str());
    
    toggleOpcoes(true);
}

// ===============================
// ======== TOGGLE OPÇÕES DOS BOTÕES
// ===============================
void MainWindow::toggleOpcoes(bool ativar)
{
    ui->btn_aula_1->setEnabled(ativar);
    ui->btn_aula_2->setEnabled(ativar);
    ui->btn_aula_3->setEnabled(ativar);
    ui->btn_aula_4->setEnabled(ativar);
    ui->btn_aula_5->setEnabled(ativar);
    ui->actionKinect->setEnabled(ativar);
    ui->actionProjetor->setEnabled(ativar);
    ui->actionCaixae_Agua->setEnabled(ativar);
    ui->actionSandbox_UC_Davis->setEnabled(ativar);
    ui->actionSite_Caixade_areia->setEnabled(ativar);
}
