
include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = hidelsitemsprefs
hidelsitemsprefs_FILES = HLSRootListController.m
hidelsitemsprefs_INSTALL_PATH = /Library/PreferenceBundles
hidelsitemsprefs_FRAMEWORKS = UIKit
hidelsitemsprefs_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/hidelsitemsprefs.plist$(ECHO_END)
