include $(THEOS)/makefiles/common.mk
ARCHS = armv7 arm64

TWEAK_NAME = PowerDown
PowerDown_FILES = Tweak.xm
PowerDown_FRAMEWORKS = UIKit

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"