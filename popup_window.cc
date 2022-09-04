#include "popup_window.h"

void PopupWindow::setOpaqueFormat(bool enable)
{
    // Opaque windows do not have an alpha channel and are guaranteed
    // to fill their entire content area. This guarantee is propagated
    // to Cocoa via the NSView opaque property.
    QSurfaceFormat format;
    format.setAlphaBufferSize(enable ? 0 : 8);
    setFormat(format);
}

void PopupWindow::setDrawAlpha(int alpha)
{
    m_drawAlpha = alpha;
    m_color.setAlpha(m_drawAlpha);
}

void PopupWindow::setColor(QColor const& color)
{
    m_color = color;
    m_color.setAlpha(m_drawAlpha);
}

void PopupWindow::setText(QString const& text)
{
    m_text = text;
}

void PopupWindow::setFontSize(int fontSize)
{
    m_fontSize = fontSize;
}

void PopupWindow::paintEvent(QPaintEvent* event)
{
    QPainter p(this);

    p.setCompositionMode (QPainter::CompositionMode_Source);
    p.fillRect(event->rect(), Qt::transparent);
    p.setCompositionMode (QPainter::CompositionMode_SourceOver);
    p.setOpacity(1);

    p.setRenderHint(QPainter::Antialiasing);
    QPainterPath path;
    path.addRoundedRect(event->rect(), 5, 5);
    QPen pen(Qt::transparent, 0);
    p.setPen(pen);
    p.fillPath(path, m_color);
    p.drawPath(path);

    pen.setColor(QColor(255, 255, 255, 255));
    QFont font;
    font.setBold(true);
    font.setPointSize(m_fontSize);

    p.setOpacity(1);
    p.setFont(font);
    p.setPen(pen);
    p.drawText(event->rect(), Qt::AlignCenter, m_text);
}
