//
//  AldGameCardEntity.h
//  leowic-3_Labb4
//
//  Created by Leonard Wickmark on 03/12/13.
//  Copyright (c) 2013 LTU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AldGameEntity;

@interface AldGameCardEntity : NSManagedObject

@property (nonatomic, retain) NSString * cardDescription;
@property (nonatomic, retain) NSString * cardTitle;
@property (nonatomic, retain) NSNumber * collected;
@property (nonatomic, retain) NSNumber * index;
@property (nonatomic, retain) AldGameEntity *game;

@end
