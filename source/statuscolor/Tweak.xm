#include <CSColorPicker/CSColorPicker.h>
NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.qiop1379.statuscolorprefs.plist"];
long long style;

%hook UIStatusBarStyleRequest
-(long long)style
{
    long long orig = %orig;
    style = orig;
    return orig;
}
-(UIColor *)foregroundColor
{
    UIColor *orig = %orig;
    if ([prefs objectForKey:@"enabled"] == NO)
    {
        return orig;
    }
    if (style == 0)
    {
        if ([prefs objectForKey:@"darkContentColor"] == nil)
        {
            return orig;
        }
        return [UIColor colorFromHexString:[prefs objectForKey:@"darkContentColor"]];
    }
    else
    {
        if ([prefs objectForKey:@"lightContentColor"] == nil)
        {
            return orig;
        }
        return [UIColor colorFromHexString:[prefs objectForKey:@"lightContentColor"]];
    }
    return orig;
}
%end