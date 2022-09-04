#pragma once

#include <QtGui>

class PopupWindow : public QRasterWindow
{
    Q_OBJECT

public:
    PopupWindow() = default;

    void setOpaqueFormat(bool enable);
    void setDrawAlpha(int alpha);
    void setColor(QColor const& color);
    void setText(QString const& text);
    void setFontSize(int fontSize);

    void paintEvent(QPaintEvent* event);

private:
    int m_drawAlpha { 255 };
    QColor m_color { 0, 0, 0, m_drawAlpha };
    QString m_text { };
    int m_fontSize { 24 };
};
