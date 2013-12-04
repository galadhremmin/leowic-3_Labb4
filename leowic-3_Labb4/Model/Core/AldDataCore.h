//
//  AldDataCore.h
//  leowic-3_Labb4
//
//  Created by Leonard Wickmark on 03/12/13.
//  Copyright (c) 2013 LTU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Managed objects/AldGameCardEntity.h"
#import "Managed objects/AldGameEntity.h"
#import "Managed objects/AldPlayerEntity.h"
#import "Managed objects/AldHighscoreEntity.h"

#define kAldDataCoreGameEntityName      @"AldGameEntity"
#define kAldDataCoreGameCardEntityName  @"AldGameCardEntity"
#define kAldDataCorePlayerEntityName    @"AldPlayerEntity"
#define kAldDataCoreHighscoreEntityName @"AldHighscoreEntity"

@interface AldDataCore : NSObject

+(AldDataCore *) defaultCore;

@property (readonly, strong, nonatomic) NSManagedObjectContext       *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel         *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

-(id)   initWithName: (NSString *)dataSourceName;
-(void) saveChanges;

@end
