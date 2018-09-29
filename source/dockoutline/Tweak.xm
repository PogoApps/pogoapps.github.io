#include <CSColorPicker/CSColorPicker.h>

@interface SBDockView : UIView
-(void)setBackgroundAlpha:(double)arg1;
@end

%hook SBDockView
-(void)layoutSubviews
{
    %orig;
    NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.qiop1379.dockoutlineprefs.plist"];
    self.layer.borderWidth = 1;
    self.layer.cornerRadius = 30;
    self.layer.masksToBounds = YES;
    if ([prefs objectForKey:@"outlineColor"] != nil)
    {
        self.layer.borderColor = [UIColor colorFromHexString:[prefs objectForKey:@"outlineColor"]].CGColor;
    }
}
-(void)setBackgroundAlpha:(double)arg1
{
    %orig(0.0f);
}
%end