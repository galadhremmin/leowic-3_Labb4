//
//  AldGameModel.h
//  leowic-3_Labb4
//
//  Created by Leonard Wickmark on 17/11/13.
//  Copyright (c) 2013 LTU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AldCardData.h"
#import "AldPlayerData.h"
#import "AldDataCore.h"

#define kAldNumberOfSimultaneousCardSelections (2)

@interface AldGameModel : NSObject

#pragma mark - Properties

@property(nonatomic)                   NSUInteger  cardsPerRow;
@property(nonatomic, readonly)         NSUInteger  pointMagnitude;
@property(nonatomic, readonly)         NSUInteger  cardsLeftToFlip;
@property(nonatomic, readonly)         NSUInteger  rounds;
@property(nonatomic, strong, readonly) NSArray    *players;

#pragma mark - Initialization

+(AldGameModel *) modelFromDataCore;

-(id)              initWithNumberOfCards: (NSUInteger)numberOfCards playersWithPortraits: (NSArray *)playerPortraitPaths;
-(id)              initWithEntity: (AldGameEntity *)modelEntity;

#pragma mark - Game logic

-(void)            preparePlayers: (NSArray *)playerPortraitPaths;
-(void)            prepareCards;
-(AldCardData *)   dataForIndex: (NSUInteger)index;
-(BOOL)            flipCards: (NSUInteger *)indexes;
-(AldPlayerData *) previousPlayer;
-(AldPlayerData *) currentPlayer;
-(AldPlayerData *) playerInTheLead;
-(void)            switchPlayers;
-(BOOL)            finishWithWinningPlayerName: (NSString *)playerName;

#pragma mark - Persistence

-(void)            persist;
-(void)            persistHighscore: (NSUInteger)score forPlayerName: (NSString *)playerName;
-(void)            loadFromEntity;

@end
