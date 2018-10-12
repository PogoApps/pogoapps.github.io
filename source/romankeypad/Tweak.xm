@interface PHHandsetDialerNumberPadButton : UIView
@end

UIView *view;

%hook PHHandsetDialerNumberPadButton
-(UIView *)circleView
{
    view = %orig;
    return view;
}
+(id)imageForCharacter:(unsigned)arg1
{
    UILabel *roman = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
    switch (arg1)
    {
        case 0:
            roman.text = @"I";
            break;
        case 1:
            roman.text = @"II";
            break;
        case 2:
            roman.text = @"III";
            break;
        case 3:
            roman.text = @"IV";
            break;
        case 4:
            roman.text = @"V";
            break;
        case 5:
            roman.text = @"VI";
            break;
        case 6:
            roman.text = @"VII";
            break;
        case 7:
            roman.text = @"IIX";
            break;
        case 8:
            roman.text = @"IX";
            break;
        default:
            return %orig;
            break;
    }
    roman.font = [UIFont systemFontOfSize:view.frame.size.width / 3];
    roman.textAlignment = NSTextAlignmentCenter;
    [view addSubview:roman];
    return %orig(-1);
}
%end