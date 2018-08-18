#line 1 "Tweak.xm"
#import <spawn.h>
#import <UIKit/UIKit.h>


@interface SBPowerDownController : UIViewController
- (void)respringPulled:(UIPanGestureRecognizer *)sender;
- (void)rebootPulled:(UIPanGestureRecognizer *)sender;
- (void)safeModePulled:(UIPanGestureRecognizer *)sender;
- (void)handlePan:(UIPanGestureRecognizer *)recognizer;
@end

@interface FBSystemService
+ (id)sharedInstance;
- (void)exitAndRelaunch:(BOOL)yes;
- (void)shutdownAndReboot:(BOOL)yes;
@end


CGFloat xmin;
CGFloat xmax;
UIImageView *respringSliderView;
UIImageView *rebootSliderView;
UIImageView *safeModeSliderView;
UILabel *respringLabel;
UILabel *rebootLabel;
UILabel *safeModeLabel;


NSData *slider = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:@"https://i.imgur.com/mq67Thv.png"]];
NSData *sliderBack = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:@"https://i.imgur.com/mCEAihe.png"]];


#include <substrate.h>
#if defined(__clang__)
#if __has_feature(objc_arc)
#define _LOGOS_SELF_TYPE_NORMAL __unsafe_unretained
#define _LOGOS_SELF_TYPE_INIT __attribute__((ns_consumed))
#define _LOGOS_SELF_CONST const
#define _LOGOS_RETURN_RETAINED __attribute__((ns_returns_retained))
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif

@class SBPowerDownController; @class _UIActionSlider; @class FBSystemService; 
static void (*_logos_orig$_ungrouped$SBPowerDownController$orderFront)(_LOGOS_SELF_TYPE_NORMAL SBPowerDownController* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$SBPowerDownController$orderFront(_LOGOS_SELF_TYPE_NORMAL SBPowerDownController* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$SBPowerDownController$respringPulled$(_LOGOS_SELF_TYPE_NORMAL SBPowerDownController* _LOGOS_SELF_CONST, SEL, UIPanGestureRecognizer *); static void _logos_method$_ungrouped$SBPowerDownController$rebootPulled$(_LOGOS_SELF_TYPE_NORMAL SBPowerDownController* _LOGOS_SELF_CONST, SEL, UIPanGestureRecognizer *); static void _logos_method$_ungrouped$SBPowerDownController$safeModePulled$(_LOGOS_SELF_TYPE_NORMAL SBPowerDownController* _LOGOS_SELF_CONST, SEL, UIPanGestureRecognizer *); 
static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$_UIActionSlider(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("_UIActionSlider"); } return _klass; }static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$FBSystemService(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("FBSystemService"); } return _klass; }
#line 32 "Tweak.xm"


static void _logos_method$_ungrouped$SBPowerDownController$orderFront(_LOGOS_SELF_TYPE_NORMAL SBPowerDownController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    _logos_orig$_ungrouped$SBPowerDownController$orderFront(self, _cmd);
    xmin = 60;
    xmax = 310;

    if (self.view.frame.size.width < 375)
    {
        xmin -= 30;
    }
    else if (self.view.frame.size.width >= 540)
    {
        xmin += 10;
        xmax -= 20;
    }

    _UIActionSlider *aslider = [[_logos_static_class_lookup$_UIActionSlider() alloc] initWithFrame:CGRectMake(self.view.frame.size.width, 150, 271, 74)];
    [srlf.view addSubview:aslider];

    





















    

    UIImageView *rebootBackgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(xmin - 4, 250, xmax - xmin + 20, 74)];
    rebootBackgroundView.image = [UIImage imageWithData:sliderBack];
    rebootBackgroundView.alpha = 0.3;
    [self.view addSubview:rebootBackgroundView];
    rebootSliderView = [[UIImageView alloc] initWithFrame:CGRectMake(xmin, 254, 66, 66)];
    rebootSliderView.image = [UIImage imageWithData:slider];
    [self.view addSubview:rebootSliderView];
    rebootLabel = [[UILabel alloc] initWithFrame:CGRectMake(xmin + 85, 260, 150, 50)];
    rebootLabel.text = @"slide to reboot";
    rebootLabel.backgroundColor = [UIColor clearColor];
    rebootLabel.textColor = [UIColor blackColor];
    rebootLabel.font = [rebootLabel.font fontWithSize:20];
    [self.view addSubview:rebootLabel];
    UIPanGestureRecognizer *rebootPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(rebootPulled:)];
    rebootPan.cancelsTouchesInView = YES;
    rebootSliderView.userInteractionEnabled = YES;
    [rebootSliderView addGestureRecognizer:rebootPan];
    [rebootPan release];

    

    UIImageView *safeModeBackgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(xmin - 4, 350, xmax - xmin + 20, 74)];
    safeModeBackgroundView.image = [UIImage imageWithData:sliderBack];
    safeModeBackgroundView.alpha = 0.3;
    [self.view addSubview:safeModeBackgroundView];
    safeModeSliderView = [[UIImageView alloc] initWithFrame:CGRectMake(xmin, 354, 66, 66)];
    safeModeSliderView.image = [UIImage imageWithData:slider];
    [self.view addSubview:safeModeSliderView];
    safeModeLabel = [[UILabel alloc] initWithFrame:CGRectMake(xmin + 85, 360, 250, 50)];
    safeModeLabel.text = @"slide to safe mode";
    safeModeLabel.backgroundColor = [UIColor clearColor];
    safeModeLabel.textColor = [UIColor blackColor];
    safeModeLabel.font = [safeModeLabel.font fontWithSize:20];
    [self.view addSubview:safeModeLabel];
    UIPanGestureRecognizer *safeModePan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(safeModePulled:)];
    safeModePan.cancelsTouchesInView = YES;
    safeModeSliderView.userInteractionEnabled = YES;
    [safeModeSliderView addGestureRecognizer:safeModePan];
    [safeModePan release];
}



static void _logos_method$_ungrouped$SBPowerDownController$respringPulled$(_LOGOS_SELF_TYPE_NORMAL SBPowerDownController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, UIPanGestureRecognizer * sender) {
    if(sender.state == UIGestureRecognizerStateEnded)
    {
        
        if (respringSliderView.frame.origin.x >= xmax - xmin + 6)
        {
            [[_logos_static_class_lookup$FBSystemService() sharedInstance] exitAndRelaunch:YES];
        }
        respringSliderView.frame = CGRectMake(xmin, 154, 66, 66);
        respringLabel.hidden = NO;
    }
    else
    {
        if (respringSliderView.frame.origin.x <= xmin)
        {
            respringLabel.hidden = NO;
        }
        else
        {
            respringLabel.hidden = YES;
        }
        CGPoint translatedPoint = [sender translationInView:sender.view.superview];
        respringSliderView.frame = CGRectMake(xmin + translatedPoint.x, 154, 66, 66);
        
        if (respringSliderView.frame.origin.x < xmin)
        {
            respringSliderView.frame = CGRectMake(xmin, 154, 66, 66);
        }
        if (respringSliderView.frame.origin.x > xmax - xmin + 6)
        {
            respringSliderView.frame = CGRectMake(xmax - xmin + 6, 154, 66, 66);
        }
    }
}



static void _logos_method$_ungrouped$SBPowerDownController$rebootPulled$(_LOGOS_SELF_TYPE_NORMAL SBPowerDownController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, UIPanGestureRecognizer * sender) {
    if(sender.state == UIGestureRecognizerStateEnded)
    {
        if (rebootSliderView.frame.origin.x >= xmax - xmin + 6)
        {
            [[_logos_static_class_lookup$FBSystemService() sharedInstance] shutdownAndReboot:YES];
        }
        rebootSliderView.frame = CGRectMake(xmin, 254, 66, 66);
        rebootLabel.hidden = NO;
    }
    else
    {
        if (rebootSliderView.frame.origin.x <= xmin)
        {
            rebootLabel.hidden = NO;
        }
        else
        {
            rebootLabel.hidden = YES;
        }
        CGPoint translatedPoint = [sender translationInView:sender.view.superview];
        rebootSliderView.frame = CGRectMake(xmin + translatedPoint.x, 254, 66, 66);
        if (rebootSliderView.frame.origin.x < xmin)
        {
            rebootSliderView.frame = CGRectMake(xmin, 254, 66, 66);
        }
        if (rebootSliderView.frame.origin.x > xmax - xmin + 6)
        {
            rebootSliderView.frame = CGRectMake(xmax - xmin + 6, 254, 66, 66);
        }
    }
}



static void _logos_method$_ungrouped$SBPowerDownController$safeModePulled$(_LOGOS_SELF_TYPE_NORMAL SBPowerDownController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, UIPanGestureRecognizer * sender) {
    if(sender.state == UIGestureRecognizerStateEnded)
    {
        if (safeModeSliderView.frame.origin.x >= xmax - xmin + 6)
        {
            

            pid_t pid;
            int status;
            const char* args[] = {"killall", "-SEGV", "SpringBoard", NULL};
            posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char* const*)args, NULL);
            waitpid(pid, &status, WEXITED);
        }
        safeModeSliderView.frame = CGRectMake(xmin, 354, 66, 66);
        safeModeLabel.hidden = NO;
    }
    else
    {
        if (safeModeSliderView.frame.origin.x <= xmin)
        {
            safeModeLabel.hidden = NO;
        }
        else
        {
            safeModeLabel.hidden = YES;
        }
        CGPoint translatedPoint = [sender translationInView:sender.view.superview];
        safeModeSliderView.frame = CGRectMake(xmin + translatedPoint.x, 354, 66, 66);
        if (safeModeSliderView.frame.origin.x < xmin)
        {
            safeModeSliderView.frame = CGRectMake(xmin, 354, 66, 66);
        }
        if (safeModeSliderView.frame.origin.x > xmax - xmin + 6)
        {
            safeModeSliderView.frame = CGRectMake(xmax - xmin + 6, 354, 66, 66);
        }
    }
}

static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$SBPowerDownController = objc_getClass("SBPowerDownController"); MSHookMessageEx(_logos_class$_ungrouped$SBPowerDownController, @selector(orderFront), (IMP)&_logos_method$_ungrouped$SBPowerDownController$orderFront, (IMP*)&_logos_orig$_ungrouped$SBPowerDownController$orderFront);{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(UIPanGestureRecognizer *), strlen(@encode(UIPanGestureRecognizer *))); i += strlen(@encode(UIPanGestureRecognizer *)); _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$SBPowerDownController, @selector(respringPulled:), (IMP)&_logos_method$_ungrouped$SBPowerDownController$respringPulled$, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(UIPanGestureRecognizer *), strlen(@encode(UIPanGestureRecognizer *))); i += strlen(@encode(UIPanGestureRecognizer *)); _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$SBPowerDownController, @selector(rebootPulled:), (IMP)&_logos_method$_ungrouped$SBPowerDownController$rebootPulled$, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(UIPanGestureRecognizer *), strlen(@encode(UIPanGestureRecognizer *))); i += strlen(@encode(UIPanGestureRecognizer *)); _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$SBPowerDownController, @selector(safeModePulled:), (IMP)&_logos_method$_ungrouped$SBPowerDownController$safeModePulled$, _typeEncoding); }} }
#line 230 "Tweak.xm"
