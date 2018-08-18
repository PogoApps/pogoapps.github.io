#import <spawn.h>
#import <UIKit/UIKit.h>
//#import <_UIActionSlider.h>

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

// declare some of the stuff i need to use in multiple methods
CGFloat xmin;
CGFloat xmax;
UIImageView *respringSliderView;
UIImageView *rebootSliderView;
UIImageView *safeModeSliderView;
UILabel *respringLabel;
UILabel *rebootLabel;
UILabel *safeModeLabel;

// i know this is jank but I didn't want to learn how to make a preference bundle for just this, once i update the tweak to include a pref bundle i will un-jank-ify this.
NSData *slider = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:@"https://i.imgur.com/mq67Thv.png"]];
NSData *sliderBack = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:@"https://i.imgur.com/mCEAihe.png"]];

%hook SBPowerDownController
- (void)orderFront
{
    %orig;
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

    _UIActionSlider *aslider = [[%c(_UIActionSlider) alloc] initWithFrame:CGRectMake(self.view.frame.size.width, 150, 271, 74)];
    [srlf.view addSubview:aslider];

    /*
    //respring slider
    
    UIImageView *respringBackgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 131.5, 150, 271, 74)];
    respringBackgroundView.image = [UIImage imageWithData:sliderBack];
    respringBackgroundView.alpha = 0.3;
    [self.view addSubview:respringBackgroundView];
    respringSliderView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 127.5, 154, 66, 66)];
    respringSliderView.image = [UIImage imageWithContentsOfFile:];
    [self.view addSubview:respringSliderView];
    respringLabel = [[UILabel alloc] initWithFrame:CGRectMake(xmin + 85, 160, 150, 50)];
   respringLabel.text = [[NSNumber numberWithFloat: self.view.frame.size.width] stringValue];
    respringLabel.backgroundColor = [UIColor clearColor];
    respringLabel.textColor = [UIColor blackColor];
    respringLabel.font = [respringLabel.font fontWithSize:20];
    [self.view addSubview:respringLabel];
    UIPanGestureRecognizer *respringPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(respringPulled:)];
    respringPan.cancelsTouchesInView = YES;
    respringSliderView.userInteractionEnabled = YES;
    [respringSliderView addGestureRecognizer:respringPan];
    [respringPan release];
    /**/
    // reboot slider

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

    // safe mode slider

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

%new
- (void)respringPulled:(UIPanGestureRecognizer *)sender
{
    if(sender.state == UIGestureRecognizerStateEnded)
    {
        // if slider is at the far right when released
        if (respringSliderView.frame.origin.x >= xmax - xmin + 6)
        {
            [[%c(FBSystemService) sharedInstance] exitAndRelaunch:YES];
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
        // keep slider in bounds
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

%new
- (void)rebootPulled:(UIPanGestureRecognizer *)sender
{
    if(sender.state == UIGestureRecognizerStateEnded)
    {
        if (rebootSliderView.frame.origin.x >= xmax - xmin + 6)
        {
            [[%c(FBSystemService) sharedInstance] shutdownAndReboot:YES];
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

%new
- (void)safeModePulled:(UIPanGestureRecognizer *)sender
{
    if(sender.state == UIGestureRecognizerStateEnded)
    {
        if (safeModeSliderView.frame.origin.x >= xmax - xmin + 6)
        {
            /* code for safemode from M4cs...
            https://github.com/M4cs/EzCC-Modules/blob/master/EzSafemode/EzSafemodeModule.m */
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
%end