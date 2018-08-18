%hook SBPasscodeNumberPadButton
+(id)imageForCharacter:(unsigned int)arg1
{
    return %orig(-1);
}
%end
// what a big tweak, days spent coding this monstrosity.
