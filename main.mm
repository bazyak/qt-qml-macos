// qt/c++
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include <memory>

#include "popup_window.h"

// objective c
#import <AppKit/AppKit.h>

#import "qml_backend.h"
#import "touchbar.h"
#import "keyboard_event_handler.h"


void customizeMainMenu()
{
    NSMenuItem* quitMenu = [[NSMenuItem alloc]
        initWithTitle: @"Quit"
        action: @selector(terminate:)
        keyEquivalent: @"q"];
    [quitMenu setTarget: NSApp];

    auto theApp = [NSApplication sharedApplication];
    auto appMenu = [[theApp.mainMenu itemAtIndex: 0] submenu];
    [appMenu removeAllItems];
    [appMenu addItem: quitMenu];
}

void setupKeyboardEventHandler()
{
    auto keyboardHandler = [KeyboardEventHandler new];
    [keyboardHandler setKeyDownEvent];
    [keyboardHandler setKeyUpEvent];

    auto popup = new PopupWindow();
    popup->setDrawAlpha(150);
    popup->setColor(QColor(60, 60, 60));
    popup->setOpaqueFormat(true);
    popup->setText("Hold ⌘Q to Quit");
    popup->setFontSize(24);

    auto const frame = NSMakeRect(0, 0, 350, 70);
    keyboardHandler.popup = [[NSPanel alloc]
        initWithContentRect: frame
        styleMask: NSWindowStyleMaskFullSizeContentView
        backing: NSBackingStoreBuffered
        defer: NO];
    auto view = (__bridge NSView*)reinterpret_cast<void*>(popup->winId()); // ARC-allowed cast
    keyboardHandler.popup.contentView = view;
    [keyboardHandler.popup orderOut: NSApp];
}


int main(int argc, char* argv[])
{
    QGuiApplication app(argc, argv);

    customizeMainMenu();

    setupKeyboardEventHandler();

    QmlBackend qmlBackend;

    // --- attach qml backend to touchbar
    auto touchbar = [TouchBar new];
    touchbar.qmlBackend = &qmlBackend;
    [touchbar attachToApplication];

    // --- accepting view type changes from touchbar or qml frontend to reload touchbar
    QObject::connect(&qmlBackend, &QmlBackend::viewTypeChanged, [&]()
    {
        qmlBackend.feedback("");
        touchbar.touchBar = nil;
    });

    //
    // --- qml frontend
    QQmlApplicationEngine engine;
    engine.addImportPath("qrc:/qml");
    QUrl const url(u"qrc:/main.qml"_qs);
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject* obj, QUrl const& objUrl)
    {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);

    // --- public backend to qml frontend
    engine.rootContext()->setContextProperty("backend", &qmlBackend);
    engine.load(url);

    return app.exec();
}
