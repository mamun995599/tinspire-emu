#ifndef QMLFRAMEBUFFER_H
#define QMLFRAMEBUFFER_H

#include <QImage>
#include <QQuickItem>

class QPainter;

/* LCD display item for the QML UI.
 *
 * The 320x240 framebuffer is uploaded as a GPU texture and drawn at the real
 * *physical* pixel size of the screen (device pixel ratio is taken into
 * account). Upscaling uses the "sharp bilinear" technique: the image is first
 * enlarged by an integer factor with nearest-neighbour (crisp pixel edges), the
 * GPU then does the remaining fractional scaling with bilinear filtering.
 * The old QQuickPaintedItem rendered in logical pixels and Android upscaled the
 * result again, which made the LCD look blurry. */
class QMLFramebuffer : public QQuickItem
{
public:
    explicit QMLFramebuffer(QQuickItem *parent = nullptr);

protected:
    QSGNode *updatePaintNode(QSGNode *oldNode, UpdatePaintNodeData *) override;

private:
    QImage m_lastSource;   // last 320x240 frame that was uploaded
    quint64 m_lastKey = 0; // size/state the last texture was built for
};

QImage renderFramebuffer();
void paintFramebuffer(QPainter *p);

#endif // QMLFRAMEBUFFER_H
