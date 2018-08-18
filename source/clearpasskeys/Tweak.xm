%hook SBPasscodeNumberPadButton
+(id)imageForCharacter:(unsigned int)arg1
{
    return %orig(-1);
}
%end