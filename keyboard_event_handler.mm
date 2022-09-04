#import "keyboard_event_handler.h"

@interface KeyboardEventHandler()

@property NSTimer* timerUp;
@property NSTimer* timerDown;

@end


#pragma mark - KeyboardEventHandler

@implementation KeyboardEventHandler

- (BOOL)respondsToSelector: (SEL)selector
{
    return [super respondsToSelector: selector];
}

- (void)quit: (id)sender
{
    [_timerDown invalidate];
    _timerDown = nil;
    [[NSApplication sharedApplication] terminate: nil];
}

- (void)cancelQuit: (id)sender
{
    [_popup orderOut: NSApp];
    [_timerUp invalidate];
    _timerUp = nil;
}

- (void)setKeyDownEvent
{
    [NSEvent addLocalMonitorForEventsMatchingMask: NSEventMaskKeyDown handler: ^NSEvent* (NSEvent* theEvent)
    {
        if (theEvent.keyCode == 12 && ([theEvent modifierFlags] & NSEventModifierFlagCommand))
        {
            if (!theEvent.isARepeat)
            {
                if ([_timerUp isValid])
                {
                    [_timerUp invalidate];
                    _timerUp = nil;
                }
                [_popup center];
                [_popup makeKeyAndOrderFront: NSApp];
                _timerDown = [NSTimer scheduledTimerWithTimeInterval: 2.0 target: self
                    selector: @selector(quit:) userInfo: nil repeats: NO];
            }
            return nil;
        }
        return theEvent;
    }];
}

- (void)setKeyUpEvent
{
    [NSEvent addLocalMonitorForEventsMatchingMask: NSEventMaskKeyUp handler: ^NSEvent* (NSEvent* theEvent)
    {
        if (theEvent.keyCode == 12)
        {
            if ([_timerDown isValid])
            {
                [_timerDown invalidate];
                _timerDown = nil;
            }
            _timerUp = [NSTimer scheduledTimerWithTimeInterval: 1.0 target: self
                selector: @selector(cancelQuit:) userInfo: nil repeats: NO];
            return nil;
        }
        return theEvent;
    }];
}

@end
