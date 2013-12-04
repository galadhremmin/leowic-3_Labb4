//
//  AldPlayerEntity.h
//  leowic-3_Labb4
//
//  Created by Leonard Wickmark on 03/12/13.
//  Copyright (c) 2013 LTU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AldGameEntity;

@interface AldPlayerEntity : NSManagedObject

@property (nonatomic, retain) NSNumber * index;
@property (nonatomic, retain) NSNumber * score;
@property (nonatomic, retain) NSString * portrait;
@property (nonatomic, retain) AldGameEntity *game;

@end
