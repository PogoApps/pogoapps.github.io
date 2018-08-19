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
    UIGraphicsBeginImageContext(size);
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

// i know this is jank but I didn't want to learn how to make a preference bundle for just this, once i update the tweak to include a pref bundle i will un-jank-ify this.
NSData *slider = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:@"https://i.imgur.com/mq67Thv.png"]];

%hook SBPowerDownController
- (void)orderFront
{
    %orig;
    
    // respring slider

    _UIActionSlider *respringSlider = [[%c(_UIActionSlider) alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 200, 150, 400, 74)];
    respringSlider.knobImage = [[UIImage imageWithData:slider] scaleToSize:CGSizeMake(66, 66)];
    respringSlider.delegate = self;
    respringSlider.trackText = @"slide to respring";
    [self.view addSubview:respringSlider];
    
    // reboot slider

    _UIActionSlider *rebootSlider = [[%c(_UIActionSlider) alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 200, 250, 400, 74)];
    rebootSlider.knobImage = [[UIImage imageWithData:slider] scaleToSize:CGSizeMake(66, 66)];
    rebootSlider.delegate = self;
    rebootSlider.trackText = @"slide to reboot";
    [self.view addSubview:rebootSlider];

    // safe mode slider

    _UIActionSlider *safeModeSlider = [[%c(_UIActionSlider) alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 200, 350, 400, 74)];
    safeModeSlider.knobImage = [[UIImage imageWithData:slider] scaleToSize:CGSizeMake(66, 66)];
    safeModeSlider.delegate = self;
    safeModeSlider.trackText = @"slide to safe mode";
    [self.view addSubview:safeModeSlider];
}

%new
-(void)actionSliderDidCompleteSlide:(id)arg1
{
    _UIActionSlider *slider = (_UIActionSlider *)arg1;
    if ([slider.trackText isEqual:@"slide to respring"])
    {
        [[%c(FBSystemService) sharedInstance] exitAndRelaunch:YES];
    }
    if ([slider.trackText isEqual:@"slide to reboot"])
    {
        [[%c(FBSystemService) sharedInstance] shutdownAndReboot:YES];
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