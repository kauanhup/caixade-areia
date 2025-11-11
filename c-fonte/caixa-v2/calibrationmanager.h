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
    
signals:
    void kinectCalibrationStarted();
    void kinectCalibrationFinished(QString output);
    void kinectCalibrationError(QString error);
    
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
    
    void saveKinectCalibration(const QString &output);
};

#endif // CALIBRATIONMANAGER_H
