#import <Cocoa/Cocoa.h>

class QmlBackend;

@interface CustomView : NSView

@property (strong) NSString* trackingLocationString;
@property QmlBackend* qmlBackend;

@end
