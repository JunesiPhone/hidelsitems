static NSString *nsDomainString = @"com.junesiphone.hidelsitemsprefs";
static NSString *nsNotificationString = @"com.junesiphone.hidelsitems/preferences.changed";

static bool hidelock;
static bool hidestatusbar;
static bool hidehome;
static bool hidehometext;
static bool hidecamera;
static bool hideflashlight;

@interface NSUserDefaults (LockPlus)
- (id)objectForKey:(NSString *)key inDomain:(NSString *)domain;
- (void)setObject:(id)value forKey:(NSString *)key inDomain:(NSString *)domain;
@end
@interface FBSystemService : NSObject
	+(id)sharedInstance;
	-(void)exitAndRelaunch:(BOOL)arg1;
@end
@interface SpringBoard : NSObject
	- (void)_relaunchSpringBoardNow;
	+(id)sharedInstance;
  -(id)_accessibilityFrontMostApplication;
  -(void)clearMenuButtonTimer;
@end

%hook SBDashBoardTeachableMomentsContainerView
- (void)_addCallToActionLabel{
	if(!hidehometext){
		%orig;
	}
}
- (void)_addHomeAffordance{
	if(!hidehome){
		%orig;
	}
}
%end

%hook SBDashBoardQuickActionsViewController
- (_Bool)hasFlashlight{
	if(hideflashlight){
		return NO;
	}else{
		return %orig;
	}
}
- (_Bool)hasCamera{
	if(hidecamera){
		return NO;
	}else{
		return %orig;
	}
}
%end

%hook SBDashBoardProudLockViewController
- (id)proudLockIconView{
	if(!hidelock){
		return %orig;
	}else{
		return nil;
	}
}
%end

%hook SBDashBoardComponent
- (id)hidden:(_Bool)arg1{
	if(!arg1 && hidestatusbar){
		NSString* str = [NSString stringWithFormat:@"%@", %orig];
		if([str containsString:@"StatusBar"]){
			arg1 = YES;
		}
	}
	return %orig;
}
%end

static void notificationCallback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
	NSNumber *n = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"hidelock" inDomain:nsDomainString];
	NSNumber *o = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"hidestatusbar" inDomain:nsDomainString];
	NSNumber *p = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"hidehome" inDomain:nsDomainString];
	NSNumber *e = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"hidehometext" inDomain:nsDomainString];
	NSNumber *m = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"hidecamera" inDomain:nsDomainString];
	NSNumber *z = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"hideflashlight" inDomain:nsDomainString];

	hidelock = (n)? [n boolValue]:NO;
	hidestatusbar = (o)? [o boolValue]:NO;
	hidehome = (p) ? [p boolValue] : NO;
	hidehometext = (e) ? [e boolValue] : NO;
	hidecamera = (m) ? [m boolValue] : NO;
	hideflashlight = (z) ? [z boolValue] : NO;
}

static void respring() {
	SpringBoard *sb = (SpringBoard *)[UIApplication sharedApplication];
  	if ([sb respondsToSelector:@selector(_relaunchSpringBoardNow)]) {
    	[sb _relaunchSpringBoardNow];
  	} else if (%c(FBSystemService)) {
    	[[%c(FBSystemService) sharedInstance] exitAndRelaunch:YES];
  	}
}

%ctor {
	notificationCallback(NULL, NULL, NULL, NULL, NULL);
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
		NULL,
		notificationCallback,
		(CFStringRef)nsNotificationString,
		NULL,
		CFNotificationSuspensionBehaviorCoalesce);
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)respring, CFSTR("com.junesiphone.hidelsitems/respring"), NULL, 0);
}