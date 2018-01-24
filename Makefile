TARGET = iphone:9.2:9.2
ARCHS = armv7 arm64

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = hidelsitems
hidelsitems_FILES = Tweak.xm

include $(THEOS_MAKE_PATH)/tweak.mk

before-stage::
	find . -name ".DS_Store" -delete

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += hidelsitemsprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
