//
//  AppDelegate.h
//  SampleApp
//
//  Created by INNOISDF700278 on 8/11/17.
//  Copyright © 2017 INNOISDF700278. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
//@property (readonly, strong) NSPersistentContainer *persistentStoreCoordinator;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

