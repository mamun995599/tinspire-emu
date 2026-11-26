#include "fbaboutdialog.h"

#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QJsonDocument>
#include <QJsonObject>

#include <QEvent>
#include <QIcon>
#include <QDialogButtonBox>
#include <QVBoxLayout>
#include <QPushButton>
#include <QTimer>

#define STRINGIFYMAGIC(x) #x
#define STRINGIFY(x) STRINGIFYMAGIC(x)

FBAboutDialog::FBAboutDialog(QWidget *parent)
    : QDialog(parent)
{
    retranslateUi();

    QIcon icon{QStringLiteral(":/icons/resources/tinspire-emu.png")};
    iconLabel.setPixmap(icon.pixmap(icon.actualSize(QSize{64, 64})));

    header.setTextInteractionFlags(Qt::TextBrowserInteraction);
    header.setOpenExternalLinks(true);

    update.setTextInteractionFlags(Qt::TextBrowserInteraction);
    update.setOpenExternalLinks(true);

    authors.setTextInteractionFlags(Qt::TextBrowserInteraction);
    authors.setOpenExternalLinks(true);

    connect(&okButton, SIGNAL(clicked(bool)), this, SLOT(close()));
    okButton.setDefault(true);

    updateButton.setAutoDefault(false);
    connect(&updateButton, SIGNAL(clicked(bool)), this, SLOT(checkForUpdate()));

    auto *buttonBox = new QDialogButtonBox(Qt::Horizontal);
    buttonBox->addButton(&okButton, QDialogButtonBox::AcceptRole);

    auto *layout = new QVBoxLayout;
    layout->addWidget(&header);
    layout->addWidget(buttonBox);

    auto *hlayout = new QHBoxLayout(this);
    hlayout->addWidget(&iconLabel);
    hlayout->addLayout(layout);
}

void FBAboutDialog::changeEvent(QEvent* event)
{
    if (event->type() == QEvent::LanguageChange)
        retranslateUi();

    QDialog::changeEvent(event);
}

void FBAboutDialog::retranslateUi()
{
    setWindowTitle(tr("About"));
    header.setText(tr("<b>Developer</b><br>"
                      "Abdullah Al Mamun<br>"
                      "Phone: +8801945120109<br>"
                      "Email: mamun995599@gmail.com<br>"
                      "Address: Siddhirganj- 1428, Narayanganj, Bangladesh."));
    authors.setText(QString());
    update.setText(QString());

    okButton.setText(tr("Ok"));
    updateButton.setText(tr("Check for Update"));

}

void FBAboutDialog::checkForUpdate()
{
    updateButton.setDisabled(true);

    if(QStringLiteral(STRINGIFY(FB_VERSION)).contains(QStringLiteral("dev")))
    {
            update.setText(tr("No updates for -dev builds available."));
            return;
    }

    checkSuccessful = false;
    update.setText(tr("Checking for updates..."));

    QNetworkRequest request(QUrl(QString::fromLatin1("https://api.github.com/repos/nspire-emus/firebird/releases/latest")));

    reply = nam.get(request);

    connect(reply, SIGNAL(finished()), this, SLOT(requestFinished()));
}

void FBAboutDialog::requestFinished()
{
    reply->deleteLater();
    updateButton.setDisabled(false);

    /* toInt() returns 0 if conversion fails. That fits nicely already. */
    int code = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();
    auto response = QJsonDocument::fromJson(reply->readAll());

    if(code != 200 || response.isEmpty())
    {
        update.setText(tr("Checking failed (%1)").arg(reply->errorString()));
        return;
    }

    QString tag_name = response.object()[QLatin1String("tag_name")].toString(),
            url = response.object()[QLatin1String("html_url")].toString(),
            title = response.object()[QLatin1String("name")].toString();

    if(tag_name == QStringLiteral("v" STRINGIFY(FB_VERSION)))
    {
        update.setText(tr("No newer version available."));
        checkSuccessful = true;
    }
    else if(tag_name.at(0) == QLatin1Char('v'))
    {
        update.setText(tr("<b>Newer version (%1) available <a href='%2'>on GitHub</a>!</b>").arg(title.toHtmlEscaped()).arg(url.toHtmlEscaped()));
        checkSuccessful = true;
    }
    else
        update.setText(tr("Checking failed (invalid tag name)"));
}

void FBAboutDialog::setVisible(bool v)
{
    QDialog::setVisible(v);
}
