//
//  AppDelegate.m
//  ToDo
//
//  Created by ZATER on 4/7/26.
//  Copyright © 2026 ZATER. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    UNUserNotificationCenter *center =
    [UNUserNotificationCenter currentNotificationCenter];

    center.delegate = self;

    [center requestAuthorizationWithOptions:
     (UNAuthorizationOptionAlert |
      UNAuthorizationOptionSound |
      UNAuthorizationOptionBadge)

                          completionHandler:
     ^(BOOL granted, NSError * _Nullable error) {

        if (granted) {
            NSLog(@"Notification Permission Granted");
        } else {
            NSLog(@"Notification Permission Denied");
        }
    }];

    return YES;
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center
willPresentNotification:(UNNotification *)notification
         withCompletionHandler:
(void (^)(UNNotificationPresentationOptions options))completionHandler {

    completionHandler(UNNotificationPresentationOptionBanner |
                      UNNotificationPresentationOptionSound |
                      UNNotificationPresentationOptionBadge);
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center
didReceiveNotificationResponse:(UNNotificationResponse *)response
         withCompletionHandler:(void(^)(void))completionHandler {

    NSLog(@"Tapped Notification: %@",
          response.notification.request.identifier);

    completionHandler();
}

@end
