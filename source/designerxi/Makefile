include $(THEOS)/makefiles/common.mk

APPLICATION_NAME = DesignerXI
DesignerXI_FILES = main.m DXIAppDelegate.m DXIRootViewController.m
DesignerXI_FRAMEWORKS = UIKit CoreGraphics
TARGET_CODESIGN_FLAGS = -S/var/mobile/ent.plist
_THEOS_PLATFORM_DPKG_DEB_COMPRESSION = lzma

include $(THEOS_MAKE_PATH)/application.mk

after-install::
	install.exec "killall \"DesignerXI\"" || true
	install.exec "chmod 6755 /usr/bin/qdexec"

SUBPROJECTS += qdexec
include $(THEOS_MAKE_PATH)/aggregate.mk
