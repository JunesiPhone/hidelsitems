#include "HLSRootListController.h"
#include "notify.h"

@implementation HLSRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"Root" target:self] retain];
	}

	return _specifiers;
}


- (void)respring:(id)sender {
  notify_post("com.junesiphone.hidelsitems/respring");
}
@end
