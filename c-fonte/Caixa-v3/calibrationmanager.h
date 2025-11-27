#ifndef CALIBRATIONMANAGER_H
#define CALIBRATIONMANAGER_H

#include <QObject>
#include <QProcess>

class CalibrationManager : public QObject
{
    Q_OBJECT
    
public:
    explicit CalibrationManager(QObject *parent = nullptr);
    
    Q_INVOKABLE void calibrateKinect();
    Q_INVOKABLE void calibrateProjector();
    Q_INVOKABLE void saveKinectCalibration();
    Q_INVOKABLE void cancelKinectCalibration();
    
signals:
    void kinectCalibrationStarted();
    void kinectCalibrationFinished(QString formattedData);
    void kinectCalibrationError(QString error);
    void kinectCalibrationClosed(QString rawOutput); // Novo sinal!
    
    void projectorCalibrationStarted();
    void projectorCalibrationFinished();
    void projectorCalibrationError(QString error);
    
private slots:
    void onKinectProcessFinished(int exitCode, QProcess::ExitStatus exitStatus);
    void onProjectorProcessFinished(int exitCode, QProcess::ExitStatus exitStatus);
    
private:
    QProcess *kinectProcess;
    QProcess *projectorProcess;
    QString capturedOutput;
    QString formattedCalibrationData;
    
    QString filterAndFormatKinectData(const QString &rawOutput);
    void saveFormattedDataToFile(const QString &formattedData);
};

#endif // CALIBRATIONMANAGER_H
