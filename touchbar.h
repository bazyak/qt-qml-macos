#import <AppKit/AppKit.h>

#import "touchbar_delegate.h"

class QmlBackend;

@interface TouchBar : QTouchBarDelegate <NSTouchBarDelegate>

@property (strong) NSCustomTouchBarItem* customViewItem;
@property (strong) IBOutlet NSScrollView* scrollView;
@property QmlBackend* qmlBackend;

@end
