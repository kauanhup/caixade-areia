#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include "aula_1.h"
#include "aula_3.h"

namespace Ui {
class MainWindow;
}

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    explicit MainWindow(QWidget *parent = nullptr);
    ~MainWindow();

protected:
    void keyPressEvent(QKeyEvent *e);

private slots:
    void on_btn_aula_1_clicked();
    void on_btn_aula_2_clicked();
    void on_btn_aula_3_clicked();
    void on_btn_aula_4_clicked();
    void on_btn_aula_5_clicked();
    
    void on_actionSite_Caixade_areia_triggered();
    void on_actionCaixae_Agua_triggered();
    void on_actionSandbox_UC_Davis_triggered();
    void on_actionProjetor_triggered();
    void on_actionKinect_triggered();

private:
    Ui::MainWindow *ui;
    Aula_1 *aula1;
    Aula_3 *aula3;
    
    void toggleOpcoes(bool ativar);
};

#endif // MAINWINDOW_H
