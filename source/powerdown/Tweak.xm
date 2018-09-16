#import <spawn.h>
#import <UIKit/UIKit.h>
#import <_UIActionSlider.h>
#import <_UIActionSliderDelegate.h>

@interface SBPowerDownController : UIViewController <_UIActionSliderDelegate>
-(void)actionSliderDidCompleteSlide:(id)arg1;
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
-(void)shutdownAndReboot:(BOOL)yes;
@end

_UIActionSlider *respringSlider;
_UIActionSlider *rebootSlider;
_UIActionSlider *safeModeSlider;

NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.qiop1379.powerdownprefs.plist"];

%hook SBPowerDownController
-(void)orderFront
{
    %orig;
    CGFloat yval = 150;
    if ([[prefs objectForKey:@"respringEnabled"] boolValue] == YES|| [prefs objectForKey:@"respringEnabled"] == nil)
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
        system("ldrestart");
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