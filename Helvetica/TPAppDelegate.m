//
//  AppDelegate.m
//  TeePee
//
//  Created by Adrian Bilescu on 9/8/15.
//  Copyright (c) 2015 Nordlogic. All rights reserved.
//

#import "TPAppDelegate.h"

#import "UINavigationBar+TeePee.h"
#import "SVProgressHUD+TPAdditions.h"

@import Fabric;
@import Crashlytics;
@import AFNetworkActivityLogger;
@import FBSDKCoreKit;

#import "TPGMSServices.h"

// Managers
#import "TPDataManager.h"

#import "TPPhotoProgressController.h"

#import "TPPhotoSequencer.h"

#import <Localytics/Localytics.h>

// Categories
#import "UIStoryboard+TPAdditions.h"
#import "CSToastManager+TPAdditions.h"


static NSString * const kGoogleAPIKey = @"AIzaSyB1wxCEIszcSUjJq-iJAVRnwriiGZK-Q1U";


@interface TPAppDelegate () <LLAnalyticsDelegate>

@property (nonatomic, strong) TPPhotoProgressController * photoProgressController;

@end

@implementation TPAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [application setApplicationIconBadgeNumber:0];
    [UINavigationBar tp_customizeAppearance];

    if ([UIViewController instancesRespondToSelector:@selector(registerForPreviewingWithDelegate:sourceView:)]) {
        
        UIApplicationShortcutItem *shortcutItem = launchOptions[UIApplicationLaunchOptionsShortcutItemKey];
        if (shortcutItem) {
            __weak typeof(self) weakSelf = self;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [weakSelf handleShortcutItem:shortcutItem];
            });
        }
    }
    
    [self performSelector:@selector(setupAfterLaunchWithOptions:)
               withObject:launchOptions
               afterDelay:0.0001];

    
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                    didFinishLaunchingWithOptions:launchOptions];
    
}

- (void)setupAfterLaunchWithOptionscaca:(NSDictionary *)launchOptions {
    TPUser *user = [TPDataManager sharedInstance].currentUser;
    if (user) {
        user.isNewUser = NO;
        if ([[[TPDataManager sharedInstance].storeManager managedObjectContext] hasChanges]) {
            [[TPDataManager sharedInstance].storeManager saveContext];
        }
        [[TPDataManager sharedInstance] updateApplicationBadge];
    }
    

    
    [Localytics autoIntegrate:@"13433a0081898201462d7dc-03713ae4-c7fc-11e5-6418-002dea3c3994" launchOptions:launchOptions];
    [Localytics addAnalyticsDelegate:self];
    
    [SVProgressHUD tp_customizeAppearance];
    [CSToastManager tp_customizeBehaviour];
    
    // File Upload Progress Bar

    
    // Crashlytics
    [Fabric with:@[[Crashlytics class]]];
    
    // Web service calls logging
    [[AFNetworkActivityLogger sharedLogger] startLogging];
    [[AFNetworkActivityLogger sharedLogger] setLevel:AFLoggerLevelDebug];
    
    [TPGMSServices provideAPIKey:kGoogleAPIKey];
    [[TPDataManager sharedInstance] syncUserData];
}



- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    NSLog(@"<%@:%@:%d>", NSStringFromClass([self class]), NSStringFromSelector(_cmd), __LINE__);
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    NSLog(@"<%@:%@:%d>", NSStringFromClass([self class]), NSStringFromSelector(_cmd), __LINE__);
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    
    ;sfsajfn fsjk
    
    sf klndfkjgn
    
    
    slfdj gnskfdjgn
    
    
    f ldkjgn
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [[TPDataManager sharedInstance] updateDeviceToken];
    [[TPDataManager sharedInstance] syncUserData];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    NSLog(@"<%@:%@:%d>", NSStringFromClass([self class]), NSStringFromSelector(_cmd), __LINE__);
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
}

- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler
{
    completionHandler([self handleShortcutItem:shortcutItem]);
}


- (BOOL)handleShortcutItem:(UIApplicationShortcutItem *)shortcutItem {
    
    TPUser *user = [TPDataManager sharedInstance].currentUser;
    if (!user || self.isCreatingPost) {
        return NO;
    }
    
    
    
    if ([shortcutItem.type isEqualToString:@"me.ios.Teepee.create-post"]) {
        TPPortraitNavController *navigation = [[UIStoryboard tp_createPostStoryboard] tp_loadVCOfType:[TPPortraitNavController class]];
        [self.mainVC presentViewController:navigation animated:YES completion:NULL];
        
    }
    
    return YES;
}

- (void)logUser {
    // You can call any combination of these three methods
    [CrashlyticsKit setUserIdentifier:@([TPDataManager sharedInstance].currentUser.identifier).stringValue];
    NSString *username = [NSString stringWithFormat:@"%@ %@", [[TPDataManager sharedInstance].currentUser firstName], [[TPDataManager sharedInstance].currentUser lastName]];
    [CrashlyticsKit setUserName:username];      
}

#pragma mark - Push Notifications

- (void)registerForPushNotifications {
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //register to receive notifications
    [application registerForRemoteNotifications];
    NSLog(@"<%@:%@:%d>", NSStringFromClass([self class]), NSStringFromSelector(_cmd), __LINE__);
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    NSString *deviceTokenString = [[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
                                    stringByReplacingOccurrencesOfString: @">" withString: @""]
                                   stringByReplacingOccurrencesOfString: @" " withString: @""] ;
    NSLog(@"Device_Token     -----> %@\n", deviceTokenString);
    
    self.deviceToken = deviceTokenString;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:deviceTokenString forKey:@"deviceToken"];
    [userDefaults synchronize];
    
    [[TPDataManager sharedInstance] updateDeviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    self.deviceToken = nil;
    [[TPDataManager sharedInstance] updateDeviceToken];
    
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
{
    //handle the actions
    if ([identifier isEqualToString:@"declineAction"]){
    }
    else if ([identifier isEqualToString:@"answerAction"]){
    }
    
    completionHandler();
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [self handleRemoteNotificationInfo:userInfo
                        fromForeground:(application.applicationState == UIApplicationStateActive)];
}

#pragma mark - Handlers

- (void)handleRemoteNotificationInfo:(NSDictionary *)userInfo fromForeground:(BOOL)fromForeground {
    if (userInfo == nil) {
        return;
    }
    
    TPAuthorizationState authState = [TPDataManager sharedInstance].authorizationState;
    
    if (authState != TPAuthorizationStateAuthorized) {
        // User is not authorized
        NSLog(@"There is no user authorized. Can't proceed handling the remote notification!");
        return;
    }
    
    NSLog(@"%@", userInfo);
    
    if (fromForeground) {
        [[TPDataManager sharedInstance] syncStreamWithCompletion:nil];
    } else {
        
        if ([TPDataManager sharedInstance].dirtyPostsExist) {
            
            [[TPDataManager sharedInstance] popDirtyObject];
            [self.mainVC goToMenuItem:TPMenuItemStream];
            [[TPDataManager sharedInstance] syncStreamWithCompletion:nil];
            
        } else {
            
            [SVProgressHUD showWithStatus:NSLocalizedString(@"Hold on a second, we're fetching your stuff...", nil)
                                 maskType:SVProgressHUDMaskTypeGradient];
            
            __weak typeof(self) weakSelf = self;
            [[TPDataManager sharedInstance] syncStreamWithCompletion:^{
                [SVProgressHUD dismiss];
                [[TPDataManager sharedInstance] popDirtyObject];
                [weakSelf.mainVC goToMenuItem:TPMenuItemStream];
            }];
            
        }
        
    }
}

#pragma mark - Getter
- (NSString *)deviceToken {
    if (_deviceToken && _deviceToken.length) {
        return _deviceToken;
    }
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    _deviceToken = [userDefaults stringForKey:@"deviceToken"];
    return _deviceToken;
}


- (TPRevealViewController *)mainVC {
    TPRevealViewController * result = (TPRevealViewController *)self.window.rootViewController;
    NSAssert([result isKindOfClass:[TPRevealViewController class]], @"TPRevealViewController expected, got %@", result);
    
    return result;
}

#pragma mark - LLAnalyticsDelegate

- (void)localyticsSessionWillOpen:(BOOL)isFirst isUpgrade:(BOOL)isUpgrade isResume:(BOOL)isResume {
    NSLog(@"<%@:%@:%d>", NSStringFromClass([self class]), NSStringFromSelector(_cmd), __LINE__);
    
    
    if (!isResume) {
        [[TPDataManager sharedInstance] logEventUserSessionFinishedResetSessionData:YES];
    }
}

- (void)localyticsSessionWillClose {
    NSLog(@"<%@:%@:%d>", NSStringFromClass([self class]), NSStringFromSelector(_cmd), __LINE__);
    
}

@end
