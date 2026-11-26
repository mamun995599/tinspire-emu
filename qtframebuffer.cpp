#include "qtframebuffer.h"

#include <array>
#include <cassert>

#include <QImage>
#include <QPainter>
#include <QQuickWindow>
#include <QSGSimpleTextureNode>
#include <QSGTexture>
#include <QGuiApplication>
#include <QScreen>

#include "core/debug.h"
#include "core/emu.h"
#include "core/lcd.h"
#include "core/misc.h"

#include "qtkeypadbridge.h"

QImage renderFramebuffer()
{
    static std::array<uint16_t, 320 * 240> framebuffer;

    lcd_cx_draw_frame(framebuffer.data());
    QImage::Format format = QImage::Format_RGB16;

    if(!emulate_cx)
    {
        format = QImage::Format_RGB444;
        uint16_t *px = framebuffer.data();
        for(unsigned int i = 0; i < 320*240; ++i)
        {
            uint8_t pix = *px & 0xF;
            uint16_t n = (pix << 8) | (pix << 4) | pix;
            *px = ~n & 0xFFF;
            ++px;
        }
    }

    QImage image(reinterpret_cast<const uchar*>(framebuffer.data()), 320, 240, 320 * 2, format);

    return image;
}

void paintFramebuffer(QPainter *p)
{
#ifdef IS_IOS_BUILD
    // Apparently, this is needed (will be 2 on retina screens)
    // TODO: actually make sure Android doesn't need that as well
    static const double devicePixelRatio = ((QGuiApplication*)QCoreApplication::instance())->primaryScreen()->devicePixelRatio();
#else
    // Has to be 1 on desktop, even on retina (tested on OS X 10.11 with one retina, one non-retina, and both ; same on Win VM)
    static const double devicePixelRatio = 1;
#endif

    QRect painterWindowScaled(p->window().topLeft(), p->window().size() / devicePixelRatio);

    if(hdq1w.lcd_contrast == 0)
    {
        p->fillRect(painterWindowScaled, emulate_cx ? Qt::black : Qt::white);
        p->setPen(emulate_cx ? Qt::white : Qt::black);
        p->drawText(painterWindowScaled, Qt::AlignCenter, QObject::tr("LCD turned off"));
    }
    else
    {
        QImage image = renderFramebuffer().scaled(p->window().size(), Qt::KeepAspectRatio, Qt::SmoothTransformation);
        image.setDevicePixelRatio(devicePixelRatio);
        p->drawImage((p->window().width() - image.width()) / 2, (p->window().height() - image.height()) / 2, image);
    }

    if(in_debugger)
    {
        p->setCompositionMode(QPainter::CompositionMode_SourceOver);
        p->fillRect(painterWindowScaled, QColor(30, 30, 30, 150));
        p->setPen(Qt::white);
        p->drawText(painterWindowScaled, Qt::AlignCenter, QObject::tr("In debugger"));
    }
}

QMLFramebuffer::QMLFramebuffer(QQuickItem *parent)
 : QQuickItem(parent)
{
    setFlag(ItemHasContents, true);
    installEventFilter(&qt_keypad_bridge);
}

QSGNode *QMLFramebuffer::updatePaintNode(QSGNode *oldNode, UpdatePaintNodeData *)
{
    QSGSimpleTextureNode *node = static_cast<QSGSimpleTextureNode *>(oldNode);
    QQuickWindow *win = window();

    if(!win || width() < 1 || height() < 1)
    {
        delete node;
        return nullptr;
    }

    const qreal dpr = win->devicePixelRatio();

    // Largest 4:3 rectangle that fits into the item, in *physical* pixels.
    const int itemPw = qMax(1, qRound(width() * dpr));
    const int itemPh = qMax(1, qRound(height() * dpr));
    int pw = itemPw;
    int ph = qRound(pw * 240.0 / 320.0);
    if(ph > itemPh)
    {
        ph = itemPh;
        pw = qRound(ph * 320.0 / 240.0);
    }
    pw = qMax(1, pw);
    ph = qMax(1, ph);

    // Centered, aligned to the physical pixel grid so that no half pixels appear.
    const QRectF rect(qRound((itemPw - pw) / 2.0) / dpr,
                      qRound((itemPh - ph) / 2.0) / dpr,
                      pw / dpr, ph / dpr);

    const bool lcdOff = hdq1w.lcd_contrast == 0;
    const bool debugger = in_debugger;
    const quint64 key = (quint64(pw) << 40) | (quint64(ph) << 16)
                        | (lcdOff ? 1u : 0u) | (debugger ? 2u : 0u) | (emulate_cx ? 4u : 0u);

    QImage source;
    if(!lcdOff)
        source = renderFramebuffer().convertToFormat(QImage::Format_RGB32);

    // Nothing changed since the last frame? Then keep the old texture, saves a lot of battery.
    if(node && key == m_lastKey && !debugger && (lcdOff || source == m_lastSource))
    {
        node->setRect(rect);
        return node;
    }

    QImage out;
    if(lcdOff)
    {
        out = QImage(pw, ph, QImage::Format_RGB32);
        out.fill(emulate_cx ? Qt::black : Qt::white);
        QPainter p(&out);
        QFont f = p.font();
        f.setPixelSize(qMax(8, ph / 14));
        p.setFont(f);
        p.setPen(emulate_cx ? Qt::white : Qt::black);
        p.drawText(out.rect(), Qt::AlignCenter, QObject::tr("LCD turned off"));
    }
    else
    {
        if(pw >= 320)
        {
            // Integer part of the zoom with nearest-neighbour -> perfectly crisp pixels.
            const int k = qBound(1, pw / 320, 6);
            out = (k == 1) ? source : source.scaled(320 * k, 240 * k, Qt::IgnoreAspectRatio, Qt::FastTransformation);
        }
        else
            out = source.scaled(pw, ph, Qt::IgnoreAspectRatio, Qt::SmoothTransformation);

        if(debugger)
        {
            QPainter p(&out);
            p.setCompositionMode(QPainter::CompositionMode_SourceOver);
            p.fillRect(out.rect(), QColor(30, 30, 30, 150));
            QFont f = p.font();
            f.setPixelSize(qMax(8, out.height() / 14));
            p.setFont(f);
            p.setPen(Qt::white);
            p.drawText(out.rect(), Qt::AlignCenter, QObject::tr("In debugger"));
        }
    }

    QSGTexture *texture = win->createTextureFromImage(out, QQuickWindow::TextureIsOpaque);
    if(!texture)
    {
        delete node;
        return nullptr;
    }

    if(!node)
    {
        node = new QSGSimpleTextureNode();
        node->setOwnsTexture(true);
    }

    texture->setFiltering(QSGTexture::Linear);
    texture->setMipmapFiltering(QSGTexture::None);
    node->setTexture(texture);     // deletes the previous texture (owned)
    node->setFiltering(QSGTexture::Linear);
    node->setRect(rect);

    m_lastKey = key;
    m_lastSource = source;

    return node;
}
