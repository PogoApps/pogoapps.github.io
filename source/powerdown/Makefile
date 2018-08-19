include $(THEOS)/makefiles/common.mk
ARCHS = armv7 armv7s arm64

TWEAK_NAME = PowerDown
PowerDown_FILES = Tweak.xm
PowerDown_FRAMEWORKS = UIKit
PowerDown_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"