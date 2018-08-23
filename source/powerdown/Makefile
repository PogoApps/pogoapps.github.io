include $(THEOS)/makefiles/common.mk
ARCHS = arm64

TWEAK_NAME = PowerDown
PowerDown_FILES = Tweak.xm
PowerDown_FRAMEWORKS = UIKit
PowerDown_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += powerdown
include $(THEOS_MAKE_PATH)/aggregate.mk
