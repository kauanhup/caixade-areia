#ifndef AULA_1_H
#define AULA_1_H

#include <QWidget>
#include <QPushButton>
#include <QLabel>
#include <QKeyEvent>
#include <QResizeEvent>

namespace Ui {
class Aula_1;
}

class Aula_1 : public QWidget
{
    Q_OBJECT

public:
    explicit Aula_1(QWidget *parent = nullptr);
    ~Aula_1();

protected:
    void keyPressEvent(QKeyEvent *event) override;
    void resizeEvent(QResizeEvent *event) override;

private slots:
    void selecionarModelo(int num);
    void salvarAlteracoes();

private:
    Ui::Aula_1 *ui;
    int modeloSelecionado;
    QString pastaBase;
    QString arquivoConfig;

    void carregarConfiguracao();
    void atualizarBotoes();
};

#endif // AULA_1_H

