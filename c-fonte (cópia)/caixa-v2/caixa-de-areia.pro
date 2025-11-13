QT += quick quickcontrols2
CONFIG += c++11

# Fonte C++
SOURCES += \
    main.cpp \
    calibrationmanager.cpp \
    sandboxmanager.cpp \
    displaymanager.cpp \
    basinmanager.cpp \
    palettemanager.cpp   # <--- ADICIONA ISSO

# Headers C++
HEADERS += \
    calibrationmanager.h \
    sandboxmanager.h \
    displaymanager.h \
    basinmanager.h \
    palettemanager.h     # <--- E ISSO AQUI

# Recursos QML
RESOURCES += qml.qrc

# Arquivos QML adicionais
QML_IMPORT_PATH =
QML_DESIGNER_IMPORT_PATH =

# Regras de instalação
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

# Definições adicionais
DEFINES += QT_DEPRECATED_WARNINGS

