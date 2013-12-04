//
//  AldGameEntity.h
//  leowic-3_Labb4
//
//  Created by Leonard Wickmark on 03/12/13.
//  Copyright (c) 2013 LTU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AldGameCardEntity, AldPlayerEntity;

@interface AldGameEntity : NSManagedObject

@property (nonatomic, retain) NSNumber * cardsPerRow;
@property (nonatomic, retain) NSNumber * currentPlayerID;
@property (nonatomic, retain) NSNumber * rounds;
@property (nonatomic, retain) NSDate * dateBegun;
@property (nonatomic, retain) NSSet *cards;
@property (nonatomic, retain) NSSet *players;
@end

@interface AldGameEntity (CoreDataGeneratedAccessors)

-(void) addCardsObject: (AldGameCardEntity *)value;
-(void) removeCardsObject: (AldGameCardEntity *)value;
-(void) addCards: (NSSet *)values;
-(void) removeCards: (NSSet *)values;

-(void) addPlayersObject: (AldPlayerEntity *)value;
-(void) removePlayersObject: (AldPlayerEntity *)value;
-(void) addPlayers: (NSSet *)values;
-(void) removePlayers: (NSSet *)values;

@end
