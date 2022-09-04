#import <AppKit/AppKit.h>

@interface KeyboardEventHandler : NSResponder

@property (strong) NSWindow* popup;

- (void)quit: (id)sender;
- (void)cancelQuit: (id)sender;
- (void)setKeyDownEvent;
- (void)setKeyUpEvent;

@end
