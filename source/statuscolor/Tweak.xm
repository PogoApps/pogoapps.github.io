#include <CSColorPicker/CSColorPicker.h>
NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.qiop1379.statuscolorprefs.plist"];
long long style;

%hook UIStatusBarStyleRequest
-(long long)style
{
    style = %orig;
    return style;
}
-(UIColor *)foregroundColor
{
    if ([prefs objectForKey:@"enabled"] != NO)
    {
        if (style == 0)
        {
            if ([prefs objectForKey:@"darkContentColor"] != nil)
            {
                return [UIColor colorFromHexString:[prefs objectForKey:@"darkContentColor"]];
            }
        }
        else
        {
            if ([prefs objectForKey:@"lightContentColor"] != nil)
            {
                return [UIColor colorFromHexString:[prefs objectForKey:@"lightContentColor"]];
            }
        }
    }
    return %orig;
}
%end
