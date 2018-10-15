#import <spawn.h>
#import <UIKit/UIKit.h>
#import <_UIActionSlider.h>
#import <_UIActionSliderDelegate.h>

@interface SBPowerDownController : UIViewController <_UIActionSliderDelegate, UIGestureRecognizerDelegate>
-(void)actionSliderDidCompleteSlide:(id)arg1;
@end

@interface SBUIPowerDownView : UIView
@end

@implementation UIImage (scale)
-(UIImage *)scaleToSize:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}
@end
    
@interface FBSystemService
+(id)sharedInstance;
-(void)exitAndRelaunch:(BOOL)yes;
@end

_UIActionSlider *respringSlider;
_UIActionSlider *rebootSlider;
_UIActionSlider *safeModeSlider;
NSMutableDictionary *prefs;

%hook SBUIPowerDownView
-(void)layoutSubviews
{
    prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.qiop1379.powerdownprefs.plist"];
    %orig;
    if ([[prefs objectForKey:@"powerEnabled"] boolValue] == NO && [prefs objectForKey:@"powerEnabled"] != nil)
    {
        [MSHookIvar<_UIActionSlider *>(self, "_actionSlider") removeFromSuperview];
    }
}
%end

%hook SBPowerDownController
-(void)orderFront
{
    prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.qiop1379.powerdownprefs.plist"];
    %orig;
    CGFloat yval = 150;
    if ([[prefs objectForKey:@"powerEnabled"] boolValue] == NO && [prefs objectForKey:@"powerEnabled"] != nil)
    {
        yval = 50;
    }
    if ([[prefs objectForKey:@"respringEnabled"] boolValue] == YES || [prefs objectForKey:@"respringEnabled"] == nil)
    {
        respringSlider = [[%c(_UIActionSlider) alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 200, yval, 400, 75)];
        respringSlider.knobImage = [[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/PowerDown.bundle/respring.png"] scaleToSize:CGSizeMake(66, 66)];
        respringSlider.delegate = self;
        respringSlider.trackText = @"slide to respring";
        [self.view addSubview:respringSlider];
        yval += 100;
    }

    if ([[prefs objectForKey:@"rebootEnabled"] boolValue] == YES || [prefs objectForKey:@"rebootEnabled"] == nil)
    {
        rebootSlider = [[%c(_UIActionSlider) alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 200, yval, 400, 75)];
        rebootSlider.knobImage = [[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/PowerDown.bundle/reboot.png"] scaleToSize:CGSizeMake(66, 66)];
        rebootSlider.knobView.frame = CGRectMake(rebootSlider.frame.origin.x, rebootSlider.frame.origin.y, 66, 66);
        rebootSlider.delegate = self;
        rebootSlider.trackText = @"slide to ldrestart";
        [self.view addSubview:rebootSlider];
        yval += 100;
    }

    if ([[prefs objectForKey:@"safeModeEnabled"] boolValue] == YES || [prefs objectForKey:@"safeModeEnabled"] == nil)
    {
        safeModeSlider = [[%c(_UIActionSlider) alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 200, yval, 400, 75)];
        safeModeSlider.knobImage = [[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/PowerDown.bundle/safemode.png"] scaleToSize:CGSizeMake(66, 66)];
        safeModeSlider.delegate = self;
        safeModeSlider.trackText = @"slide to safe mode";
        [self.view addSubview:safeModeSlider];
    }
}

-(void)cancel
{
    respringSlider.frame = CGRectMake(0, -100, 400, 75);
    rebootSlider.frame = CGRectMake(0, -100, 400, 75);
    safeModeSlider.frame = CGRectMake(0, -100, 400, 75);
    %orig;
}

%new
-(void)actionSliderDidCompleteSlide:(id)arg1
{
    _UIActionSlider *slider = (_UIActionSlider *)arg1;
    if ([slider.trackText isEqual:@"slide to respring"])
    {
        [[%c(FBSystemService) sharedInstance] exitAndRelaunch:YES];
    }
    if ([slider.trackText isEqual:@"slide to ldrestart"])
    {
        pid_t pid;
        int status;
        const char *args[] = {"ldRun", NULL};
        posix_spawn(&pid, "/usr/bin/ldRun", NULL, NULL, (char* const*)args, NULL);
        waitpid(pid, &status, WEXITED);
    }
    if ([slider.trackText isEqual:@"slide to safe mode"])
    {
        pid_t pid;
        int status;
        const char* args[] = {"killall", "-SEGV", "SpringBoard", NULL};
        posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char* const*)args, NULL);
        waitpid(pid, &status, WEXITED);
    }
}
%end