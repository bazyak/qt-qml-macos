  QT += quick widgets

# Input
HEADERS += \
    auto_property.h \
    custom_view.h \
    keyboard_event_handler.h \
    popup_window.h \
    qml_backend.h \
    touchbar.h \
    touchbar_delegate.h

OBJECTIVE_SOURCES += \
    custom_view.mm \
    main.mm \
    touchbar_delegate.mm \
    touchbar.mm \
    keyboard_event_handler.mm

SOURCES += \
    popup_window.cc

LIBS += -framework AppKit

macx: {
    QMAKE_MACOSX_DEPLOYMENT_TARGET = 12.3
}

CONFIG += c++17

# resources.files = main.qml
# resources.prefix = /$${TARGET}
RESOURCES += \
    resources.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH = qml

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

APP_QML_FILES.files = img/sunset.png
APP_QML_FILES.path = Contents/Resources
QMAKE_BUNDLE_DATA += APP_QML_FILES

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target
