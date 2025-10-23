#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <QKeyEvent>
#include "aula_2.h"

#include <stdlib.h>
#include <iostream>
#include <string>

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

    void on_actionProjetor_triggered();
    void on_actionKinect_triggered();

private:
    Ui::MainWindow *ui;
    Aula_2 *aula2;

    void toggleOpcoes(bool ativar);
};

#endif // MAINWINDOW_H
