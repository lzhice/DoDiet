#include "pdfcreator.h"


PDFCreator::PDFCreator(QObject *parent) : QObject(parent)
{

}

QString PDFCreator::makePdf(QString text)
{
    QString fileName = QDir::homePath()+QDir::separator()+"export.pdf";
    QPrinter printer(QPrinter::PrinterResolution);
    printer.setOutputFormat(QPrinter::PdfFormat);
    printer.setPaperSize(QPrinter::A4);
    printer.setOutputFileName(fileName);
    QTextDocument doc;
    doc.setHtml(text);
    doc.setPageSize(printer.pageRect().size()); // This is necessary if you want to hide the page number
    doc.print(&printer);
    return fileName;
}
