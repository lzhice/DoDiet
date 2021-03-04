#ifndef PDFCREATOR_H
#define PDFCREATOR_H
#include <QObject>
#include <QtPrintSupport/QPrinter>
#include <QtPrintSupport/QPrintDialog>
#include <QTextDocument>
#include <QDir>
class PDFCreator : public QObject
{
    Q_OBJECT
public:
    explicit PDFCreator(QObject *parent = nullptr);
    Q_INVOKABLE QString makePdf(QString text);

signals:

};

#endif // PDFCREATOR_H
