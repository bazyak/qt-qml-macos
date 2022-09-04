#pragma once

#include <QObject>
#include <QString>

#include "auto_property.h"

class QmlBackend : public QObject
{
    Q_OBJECT

    AUTO_PROPERTY(QString, feedback)
    AUTO_PROPERTY(bool, viewType)

public:
    explicit QmlBackend(QObject* parent = nullptr)
    {
        Q_UNUSED(parent)

        viewType(false);
    }
};
