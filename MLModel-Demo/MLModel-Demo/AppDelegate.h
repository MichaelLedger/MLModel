//
//  AppDelegate.h
//  MLModel-Demo
//
//  Created by MichaelLedger on 2021/2/24.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (readonly, strong) NSPersistentCloudKitContainer *persistentContainer API_AVAILABLE(ios(13.0));

- (void)saveContext;


@end

