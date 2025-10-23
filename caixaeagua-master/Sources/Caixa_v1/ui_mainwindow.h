/********************************************************************************
** Form generated from reading UI file 'mainwindow.ui'
**
** Created by: Qt User Interface Compiler version 5.9.5
**
** WARNING! All changes made in this file will be lost when recompiling UI file!
********************************************************************************/

#ifndef UI_MAINWINDOW_H
#define UI_MAINWINDOW_H

#include <QtCore/QVariant>
#include <QtWidgets/QAction>
#include <QtWidgets/QApplication>
#include <QtWidgets/QButtonGroup>
#include <QtWidgets/QHBoxLayout>
#include <QtWidgets/QHeaderView>
#include <QtWidgets/QLabel>
#include <QtWidgets/QMainWindow>
#include <QtWidgets/QMenu>
#include <QtWidgets/QMenuBar>
#include <QtWidgets/QPushButton>
#include <QtWidgets/QWidget>

QT_BEGIN_NAMESPACE

class Ui_MainWindow
{
public:
    QAction *actionAula_1;
    QAction *actionAula_2;
    QAction *actionAula_3;
    QAction *actionAula_4;
    QAction *actionAula_5;
    QAction *actionSite_do_Caixa_e_gua;
    QAction *actionPerguntas_Frequ_ntes;
    QAction *actionCr_ditos;
    QAction *actionProjetor;
    QAction *actionMundo;
    QAction *actionKinect;
    QAction *actionCaixae_Agua;
    QAction *actionSandbox_UC_Davis;
    QWidget *centralWidget;
    QWidget *verticalLayoutWidget;
    QHBoxLayout *horizontalLayout;
    QPushButton *btn_aula_1;
    QPushButton *btn_aula_2;
    QLabel *imagem;
    QMenuBar *menuBar;
    QMenu *menuCalibrar;
    QMenu *menuSobre;
    QMenu *menuCr_ditos;

    void setupUi(QMainWindow *MainWindow)
    {
        if (MainWindow->objectName().isEmpty())
            MainWindow->setObjectName(QStringLiteral("MainWindow"));
        MainWindow->resize(650, 545);
        MainWindow->setMinimumSize(QSize(650, 545));
        MainWindow->setMaximumSize(QSize(650, 545));
        QIcon icon;
        icon.addFile(QStringLiteral("../resources/logos/icone.jpg"), QSize(), QIcon::Normal, QIcon::On);
        MainWindow->setWindowIcon(icon);
        MainWindow->setIconSize(QSize(48, 48));
        actionAula_1 = new QAction(MainWindow);
        actionAula_1->setObjectName(QStringLiteral("actionAula_1"));
        actionAula_2 = new QAction(MainWindow);
        actionAula_2->setObjectName(QStringLiteral("actionAula_2"));
        actionAula_3 = new QAction(MainWindow);
        actionAula_3->setObjectName(QStringLiteral("actionAula_3"));
        actionAula_4 = new QAction(MainWindow);
        actionAula_4->setObjectName(QStringLiteral("actionAula_4"));
        actionAula_5 = new QAction(MainWindow);
        actionAula_5->setObjectName(QStringLiteral("actionAula_5"));
        actionSite_do_Caixa_e_gua = new QAction(MainWindow);
        actionSite_do_Caixa_e_gua->setObjectName(QStringLiteral("actionSite_do_Caixa_e_gua"));
        actionPerguntas_Frequ_ntes = new QAction(MainWindow);
        actionPerguntas_Frequ_ntes->setObjectName(QStringLiteral("actionPerguntas_Frequ_ntes"));
        actionCr_ditos = new QAction(MainWindow);
        actionCr_ditos->setObjectName(QStringLiteral("actionCr_ditos"));
        actionProjetor = new QAction(MainWindow);
        actionProjetor->setObjectName(QStringLiteral("actionProjetor"));
        actionMundo = new QAction(MainWindow);
        actionMundo->setObjectName(QStringLiteral("actionMundo"));
        actionKinect = new QAction(MainWindow);
        actionKinect->setObjectName(QStringLiteral("actionKinect"));
        actionCaixae_Agua = new QAction(MainWindow);
        actionCaixae_Agua->setObjectName(QStringLiteral("actionCaixae_Agua"));
        actionSandbox_UC_Davis = new QAction(MainWindow);
        actionSandbox_UC_Davis->setObjectName(QStringLiteral("actionSandbox_UC_Davis"));
        centralWidget = new QWidget(MainWindow);
        centralWidget->setObjectName(QStringLiteral("centralWidget"));
        verticalLayoutWidget = new QWidget(centralWidget);
        verticalLayoutWidget->setObjectName(QStringLiteral("verticalLayoutWidget"));
        verticalLayoutWidget->setGeometry(QRect(10, 460, 631, 52));
        horizontalLayout = new QHBoxLayout(verticalLayoutWidget);
        horizontalLayout->setSpacing(6);
        horizontalLayout->setContentsMargins(11, 11, 11, 11);
        horizontalLayout->setObjectName(QStringLiteral("horizontalLayout"));
        horizontalLayout->setContentsMargins(0, 0, 0, 0);
        btn_aula_1 = new QPushButton(verticalLayoutWidget);
        btn_aula_1->setObjectName(QStringLiteral("btn_aula_1"));
        QSizePolicy sizePolicy(QSizePolicy::Preferred, QSizePolicy::Preferred);
        sizePolicy.setHorizontalStretch(0);
        sizePolicy.setVerticalStretch(0);
        sizePolicy.setHeightForWidth(btn_aula_1->sizePolicy().hasHeightForWidth());
        btn_aula_1->setSizePolicy(sizePolicy);
        btn_aula_1->setMinimumSize(QSize(0, 50));
        QPalette palette;
        QBrush brush(QColor(110, 110, 110, 255));
        brush.setStyle(Qt::SolidPattern);
        palette.setBrush(QPalette::Active, QPalette::WindowText, brush);
        palette.setBrush(QPalette::Active, QPalette::Text, brush);
        palette.setBrush(QPalette::Active, QPalette::ButtonText, brush);
        palette.setBrush(QPalette::Active, QPalette::ToolTipText, brush);
        palette.setBrush(QPalette::Inactive, QPalette::WindowText, brush);
        palette.setBrush(QPalette::Inactive, QPalette::Text, brush);
        palette.setBrush(QPalette::Inactive, QPalette::ButtonText, brush);
        palette.setBrush(QPalette::Inactive, QPalette::ToolTipText, brush);
        QBrush brush1(QColor(190, 190, 190, 255));
        brush1.setStyle(Qt::SolidPattern);
        palette.setBrush(QPalette::Disabled, QPalette::WindowText, brush1);
        palette.setBrush(QPalette::Disabled, QPalette::Text, brush1);
        palette.setBrush(QPalette::Disabled, QPalette::ButtonText, brush1);
        palette.setBrush(QPalette::Disabled, QPalette::ToolTipText, brush);
        btn_aula_1->setPalette(palette);
        QFont font;
        font.setFamily(QStringLiteral("Sans Serif"));
        font.setPointSize(16);
        font.setBold(true);
        font.setItalic(false);
        font.setWeight(75);
        btn_aula_1->setFont(font);
        btn_aula_1->setCursor(QCursor(Qt::PointingHandCursor));
        btn_aula_1->setToolTipDuration(-1);

        horizontalLayout->addWidget(btn_aula_1);

        btn_aula_2 = new QPushButton(verticalLayoutWidget);
        btn_aula_2->setObjectName(QStringLiteral("btn_aula_2"));
        sizePolicy.setHeightForWidth(btn_aula_2->sizePolicy().hasHeightForWidth());
        btn_aula_2->setSizePolicy(sizePolicy);
        btn_aula_2->setMinimumSize(QSize(0, 50));
        QPalette palette1;
        palette1.setBrush(QPalette::Active, QPalette::ButtonText, brush);
        palette1.setBrush(QPalette::Inactive, QPalette::ButtonText, brush);
        palette1.setBrush(QPalette::Disabled, QPalette::ButtonText, brush1);
        btn_aula_2->setPalette(palette1);
        btn_aula_2->setFont(font);
        btn_aula_2->setCursor(QCursor(Qt::PointingHandCursor));

        horizontalLayout->addWidget(btn_aula_2);

        imagem = new QLabel(centralWidget);
        imagem->setObjectName(QStringLiteral("imagem"));
        imagem->setGeometry(QRect(10, 0, 631, 451));
        imagem->setPixmap(QPixmap(QString::fromUtf8("../resources/logos/LOGO ICONE.png")));
        imagem->setScaledContents(true);
        MainWindow->setCentralWidget(centralWidget);
        menuBar = new QMenuBar(MainWindow);
        menuBar->setObjectName(QStringLiteral("menuBar"));
        menuBar->setGeometry(QRect(0, 0, 650, 24));
        QSizePolicy sizePolicy1(QSizePolicy::MinimumExpanding, QSizePolicy::Minimum);
        sizePolicy1.setHorizontalStretch(0);
        sizePolicy1.setVerticalStretch(0);
        sizePolicy1.setHeightForWidth(menuBar->sizePolicy().hasHeightForWidth());
        menuBar->setSizePolicy(sizePolicy1);
        menuCalibrar = new QMenu(menuBar);
        menuCalibrar->setObjectName(QStringLiteral("menuCalibrar"));
        menuSobre = new QMenu(menuBar);
        menuSobre->setObjectName(QStringLiteral("menuSobre"));
        menuCr_ditos = new QMenu(menuSobre);
        menuCr_ditos->setObjectName(QStringLiteral("menuCr_ditos"));
        MainWindow->setMenuBar(menuBar);

        menuBar->addAction(menuCalibrar->menuAction());
        menuBar->addAction(menuSobre->menuAction());
        menuCalibrar->addSeparator();
        menuCalibrar->addAction(actionKinect);
        menuCalibrar->addAction(actionProjetor);
        menuSobre->addAction(actionCr_ditos);
        menuSobre->addSeparator();
        menuSobre->addAction(menuCr_ditos->menuAction());
        menuCr_ditos->addAction(actionCaixae_Agua);
        menuCr_ditos->addAction(actionSandbox_UC_Davis);

        retranslateUi(MainWindow);

        QMetaObject::connectSlotsByName(MainWindow);
    } // setupUi

    void retranslateUi(QMainWindow *MainWindow)
    {
        MainWindow->setWindowTitle(QApplication::translate("MainWindow", "caixade-areia", Q_NULLPTR));
        actionAula_1->setText(QApplication::translate("MainWindow", "Aula 1", Q_NULLPTR));
        actionAula_2->setText(QApplication::translate("MainWindow", "Aula 2", Q_NULLPTR));
#ifndef QT_NO_TOOLTIP
        actionAula_2->setToolTip(QApplication::translate("MainWindow", "Bacia Hidrogr\303\241fica", Q_NULLPTR));
#endif // QT_NO_TOOLTIP
        actionAula_3->setText(QApplication::translate("MainWindow", "Aula 3", Q_NULLPTR));
        actionAula_4->setText(QApplication::translate("MainWindow", "Aula 4", Q_NULLPTR));
        actionAula_5->setText(QApplication::translate("MainWindow", "Aula 5", Q_NULLPTR));
        actionSite_do_Caixa_e_gua->setText(QApplication::translate("MainWindow", "Site do Caixa e-\303\201gua", Q_NULLPTR));
        actionPerguntas_Frequ_ntes->setText(QApplication::translate("MainWindow", "Perguntas Frequentes", Q_NULLPTR));
        actionCr_ditos->setText(QApplication::translate("MainWindow", "Vers\303\243o adaptada para fins educativos \342\200\224 Escola Rangel Torres", Q_NULLPTR));
        actionProjetor->setText(QApplication::translate("MainWindow", "Projetor", Q_NULLPTR));
#ifndef QT_NO_SHORTCUT
        actionProjetor->setShortcut(QApplication::translate("MainWindow", "P", Q_NULLPTR));
#endif // QT_NO_SHORTCUT
        actionMundo->setText(QApplication::translate("MainWindow", "Mundo", Q_NULLPTR));
#ifndef QT_NO_SHORTCUT
        actionMundo->setShortcut(QApplication::translate("MainWindow", "M", Q_NULLPTR));
#endif // QT_NO_SHORTCUT
        actionKinect->setText(QApplication::translate("MainWindow", "Kinect", Q_NULLPTR));
#ifndef QT_NO_SHORTCUT
        actionKinect->setShortcut(QApplication::translate("MainWindow", "K", Q_NULLPTR));
#endif // QT_NO_SHORTCUT
        actionCaixae_Agua->setText(QApplication::translate("MainWindow", "Caixae-Agua", Q_NULLPTR));
        actionSandbox_UC_Davis->setText(QApplication::translate("MainWindow", "Sandbox (UC Davis)", Q_NULLPTR));
#ifndef QT_NO_TOOLTIP
        btn_aula_1->setToolTip(QApplication::translate("MainWindow", "<html><head/><body><p align=\"center\"><span style=\" font-size:10pt; font-family: 'Comic Sans MS'; \">Inicia a aula 1</span></p></body></html>", Q_NULLPTR));
#endif // QT_NO_TOOLTIP
#ifndef QT_NO_WHATSTHIS
        btn_aula_1->setWhatsThis(QString());
#endif // QT_NO_WHATSTHIS
        btn_aula_1->setText(QApplication::translate("MainWindow", "Abrir Sandbox", Q_NULLPTR));
#ifndef QT_NO_SHORTCUT
        btn_aula_1->setShortcut(QApplication::translate("MainWindow", "1", Q_NULLPTR));
#endif // QT_NO_SHORTCUT
#ifndef QT_NO_TOOLTIP
        btn_aula_2->setToolTip(QApplication::translate("MainWindow", "<html><head/><body><p align=\"center\"><span style=\" font-size:10pt; font-family: 'Comic Sans MS'; \">Inicia a aula 2</span></p></body></html>", Q_NULLPTR));
#endif // QT_NO_TOOLTIP
        btn_aula_2->setText(QApplication::translate("MainWindow", "Calibrar Kinect", Q_NULLPTR));
#ifndef QT_NO_SHORTCUT
        btn_aula_2->setShortcut(QApplication::translate("MainWindow", "2", Q_NULLPTR));
#endif // QT_NO_SHORTCUT
        imagem->setText(QString());
        menuCalibrar->setTitle(QApplication::translate("MainWindow", "Calibrar", Q_NULLPTR));
        menuSobre->setTitle(QApplication::translate("MainWindow", "Sobre", Q_NULLPTR));
        menuCr_ditos->setTitle(QApplication::translate("MainWindow", "Cr\303\251ditos", Q_NULLPTR));
    } // retranslateUi

};

namespace Ui {
    class MainWindow: public Ui_MainWindow {};
} // namespace Ui

QT_END_NAMESPACE

#endif // UI_MAINWINDOW_H
