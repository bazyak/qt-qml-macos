#import "touchbar.h"

#import "custom_view.h"
#import "qml_backend.h"

@implementation TouchBar

// Create identifiers for two button items.
static NSTouchBarItemIdentifier const TouchesButtonIdentifier = @"com.rb.tbex.TouchesButtonIdentifier";
static NSTouchBarItemIdentifier const GesturesButtonIdentifier = @"com.rb.tbex.GesturesButtonIdentifier";
static NSTouchBarItemIdentifier const CustomViewIdentifier = @"com.rb.tbex.CustomViewIdentifier";
static NSTouchBarItemIdentifier const ScrollViewIdentifier = @"com.rb.tbex.ScrollViewIdentifier";

- (NSTouchBar*)makeTouchBar
{
    // Create the touch bar with this instance as its delegate
    auto bar = [[NSTouchBar alloc] init];
    bar.delegate = self;

    // Add touch bar items:
    bar.defaultItemIdentifiers = @[TouchesButtonIdentifier, GesturesButtonIdentifier,
        CustomViewIdentifier, ScrollViewIdentifier];

    bar.customizationAllowedItemIdentifiers = @[CustomViewIdentifier, ScrollViewIdentifier];

    return bar;
}

- (NSTouchBarItem*)touchBar: (NSTouchBar*)touchBar makeItemForIdentifier: (NSTouchBarItemIdentifier)identifier
{
    Q_UNUSED(touchBar);

    auto item = [[NSCustomTouchBarItem alloc] initWithIdentifier: identifier];

    // Create touch bar items as NSCustomTouchBarItems which can contain any NSView.
    if ([identifier isEqualToString: TouchesButtonIdentifier])
    {
        QString const title = "Touches";
        item.view = [NSButton buttonWithTitle: title.toNSString() target: self action: @selector(touchesButtonClicked)];
    }
    else if ([identifier isEqualToString: GesturesButtonIdentifier])
    {
        QString const title = "Gestures";
        item.view = [NSButton buttonWithTitle: title.toNSString() target: self action: @selector(gesturesButtonClicked)];
    }
    else if ([identifier isEqualToString: CustomViewIdentifier])
    {
        NSView* customView = nil;

        if (_qmlBackend->viewType())
        {
            // Create the custom view that analyzes touch events.
            customView = [[CustomView alloc] initWithFrame: NSZeroRect];

            customView.wantsLayer = YES;
            customView.layer.backgroundColor = [self colorWithHexColorString: @"00ced1"].CGColor;

            customView.allowedTouchTypes = NSTouchTypeMaskDirect;

            // This is so you can report the view's touch location to the feedback label.
            reinterpret_cast<CustomView*>(customView).qmlBackend = _qmlBackend;
            //[self.str unbind:NSValueBinding];
            //[self.str bind:NSValueBinding toObject:customView withKeyPath:@"trackingLocationString" options:nil];
        }
        else
        {
            // Create the custom view that uses gesture recognizers.
            customView = [[NSView alloc] initWithFrame: NSZeroRect];

            customView.wantsLayer = YES;
            customView.layer.backgroundColor = [self colorWithHexColorString: @"ffa500"].CGColor;

            // This is for pan gesture recognizer to work.
            customView.allowedTouchTypes = NSTouchTypeMaskDirect;

            auto panGesture = [[NSPanGestureRecognizer alloc] initWithTarget: self action: @selector(panAction:)];
            panGesture.allowedTouchTypes = NSTouchTypeMaskDirect;
            [customView addGestureRecognizer: panGesture];
        }
        item.view = customView;
        item.customizationLabel = NSLocalizedString(@"Custom View", @"");
        _customViewItem = item;
    }
    else if ([identifier isEqualToString: ScrollViewIdentifier])
    {
        auto myImagePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingString: @"/sunset.png"];
        auto image = [[[NSImage alloc] initWithContentsOfFile: myImagePath] autorelease];

        auto imageView = [[NSImageView alloc] initWithFrame: NSMakeRect(0, 0, image.size.width, image.size.height)];
        [imageView setImage: image];

        self.scrollView = [[NSScrollView alloc] initWithFrame: NSMakeRect(0, 0, image.size.width, image.size.height)];
        // configure the scroll view
        [self.scrollView setBorderType: NSNoBorder];
        // embed your custom view in the scroll view
        [self.scrollView setDocumentView: imageView];

        //auto window = new CheckeredWindow();
        //item.view = (__bridge NSView*)reinterpret_cast<void*>(window->winId());
        item.view = self.scrollView;
        item.customizationLabel = NSLocalizedString(@"Scroll View", @"");
    }
    else
    {
        item = nil;
    }
    return item;
}

- (void)panAction: (NSGestureRecognizer*)sender
{
    // The pan gesture recognizer calls this action method.
    auto const gesture = sender;
    auto const location = [gesture locationInView: self.customViewItem.view]; // NSPoint

    QString feedback = "Pan Gesture: ";
    switch (gesture.state)
    {
        case NSGestureRecognizerStateBegan:
            feedback += "Began";
            break;
        case NSGestureRecognizerStateChanged:
            feedback += "Changed";
            break;
        case NSGestureRecognizerStateEnded:
            feedback += "Ended";
            break;
        default:
            break;
    }

    feedback += QString(" { x = %1 }").arg(location.x);
    _qmlBackend->feedback(feedback);
}

- (void)touchesButtonClicked
{
    _qmlBackend->viewType(true);
}

- (void)gesturesButtonClicked
{
    _qmlBackend->viewType(false);
}

- (NSColor*)colorWithHexColorString: (NSString*)inColorString
{
    NSColor* result = nil;
    unsigned colorCode = 0;
    unsigned char redByte, greenByte, blueByte;

    if (inColorString != nil)
    {
         NSScanner* scanner = [NSScanner scannerWithString: inColorString];
         [scanner scanHexInt: &colorCode]; // ignore error
    }
    redByte = (unsigned char)(colorCode >> 16);
    greenByte = (unsigned char)(colorCode >> 8);
    blueByte = (unsigned char)(colorCode); // masks off high bits

    result = [NSColor
        colorWithCalibratedRed: (CGFloat)redByte / 0xff
        green: (CGFloat)greenByte / 0xff
        blue: (CGFloat)blueByte / 0xff
        alpha: 1.0];
    return result;
}

@end
