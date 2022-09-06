#import "keyboard_event_handler.h"

@interface KeyboardEventHandler()
{
    NSTimer* timerUp;
    NSTimer* timerDown;
}
@end


#pragma mark - KeyboardEventHandler

@implementation KeyboardEventHandler

- (void)dealloc
{
    [_popup release];
    _popup = nil;
    [super dealloc];
}

- (BOOL)respondsToSelector: (SEL)selector
{
    return [super respondsToSelector: selector];
}

- (void)quit: (id)sender
{
    [timerDown invalidate];
    timerDown = nil;
    [[NSApplication sharedApplication] terminate: nil];
}

- (void)cancelQuit: (id)sender
{
    [_popup orderOut: NSApp];
    [timerUp invalidate];
    timerUp = nil;
}

- (void)setKeyDownEvent
{
    [NSEvent addLocalMonitorForEventsMatchingMask: NSEventMaskKeyDown handler: ^NSEvent* (NSEvent* theEvent)
    {
        if (theEvent.keyCode == 12 && ([theEvent modifierFlags] & NSEventModifierFlagCommand))
        {
            if (!theEvent.isARepeat)
            {
                if ([timerUp isValid])
                {
                    [timerUp invalidate];
                    timerUp = nil;
                }
                [_popup center];
                [_popup makeKeyAndOrderFront: NSApp];
                timerDown = [NSTimer scheduledTimerWithTimeInterval: 2.0 target: self
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
            if ([timerDown isValid])
            {
                [timerDown invalidate];
                timerDown = nil;
            }
            timerUp = [NSTimer scheduledTimerWithTimeInterval: 1.0 target: self
                selector: @selector(cancelQuit:) userInfo: nil repeats: NO];
            return nil;
        }
        return theEvent;
    }];
}

@end
