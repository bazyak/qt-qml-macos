#import "custom_view.h"

#include "qml_backend.h"

@interface CustomView()

@property NSInteger selection;
@property NSInteger oldSelection;
@property id trackingTouchIdentity;

@end


#pragma mark - CustomView

@implementation CustomView

- (void)dealloc
{
    [_trackingLocationString release];
    _trackingLocationString = nil;
    [super dealloc];
}

- (BOOL)acceptsFirstResponder
{
    return YES;
}

- (void)touchesBeganWithEvent: (NSEvent*)event
{
    // You're already tracking a touch, so this must be a new touch.
    // What should you do? Cancel or ignore.
    //
    if (_trackingTouchIdentity == nil)
    {
        auto touches = [event touchesMatchingPhase: NSTouchPhaseBegan inView: self]; // NSSet<NSTouch*>*
        // Note: Touches may contain zero, one, or more touches.
        // What to do if there is more than one touch?
        // In this example, randomly pick a touch to track and ignore the other one.

        auto const touch = touches.anyObject;
        if (touch != nil)
        {
            if (touch.type == NSTouchTypeDirect)
            {
                _trackingTouchIdentity = touch.identity;

                // Remember the selection value at the start of tracking in case you need to cancel.
                _oldSelection = _selection;

                auto const location = [touch locationInView: self]; // NSPoint
                _qmlBackend->feedback(QString("Began at: { x = %1 }").arg(location.x));
            }
        }
    }

    [super touchesBeganWithEvent: event];
}

- (void)touchesMovedWithEvent: (NSEvent*)event
{
    if (_trackingTouchIdentity)
    {
        for (NSTouch* touch in [event touchesMatchingPhase: NSTouchPhaseMoved inView: self])
        {
            if (touch.type == NSTouchTypeDirect && [_trackingTouchIdentity isEqual: touch.identity])
            {
                auto const location = [touch locationInView: self];
                _qmlBackend->feedback(QString("Moved at: { x = %1 }").arg(location.x));

                break;
            }
        }
    }

    [super touchesMovedWithEvent: event];
}

- (void)touchesEndedWithEvent: (NSEvent*)event
{
    if (_trackingTouchIdentity)
    {
        for (NSTouch* touch in [event touchesMatchingPhase: NSTouchPhaseEnded inView: self])
        {
            if (touch.type == NSTouchTypeDirect && [_trackingTouchIdentity isEqual: touch.identity])
            {
                // Finshed tracking successfully.
                _trackingTouchIdentity = nil;

                auto const location = [touch locationInView: self];
                _qmlBackend->feedback(QString("Ended at: { x = %1 }").arg(location.x));

                break;
            }
        }
    }

    [super touchesEndedWithEvent: event];
}

- (void)touchesCancelledWithEvent: (NSEvent*)event
{
    if (_trackingTouchIdentity)
    {
        for (NSTouch* touch in [event touchesMatchingPhase: NSTouchPhaseMoved inView: self])
        {
            if (touch.type == NSTouchTypeDirect && [_trackingTouchIdentity isEqual: touch.identity])
            {
                // CANCEL
                // This can happen for a number of reasons.
                // # A gesture recognizer started recognizing a touch.
                // # The underlying touch context changed (the user pressed Command-Tab while interacting with this view).
                // # The hardware canceled the touch.
                // Whatever the reason, put things back the way they were. In this example, reset the selection.
                //
                _trackingTouchIdentity = nil;

                _selection = _oldSelection;

                auto const location = [touch locationInView: self];
                _qmlBackend->feedback(QString("Canceled at: { x = %1 }").arg(location.x));
            }
        }
    }

    [super touchesCancelledWithEvent: event];
}

@end
