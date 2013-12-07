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

// Restores the last, unfinished game from the AldDataCore.
+(AldGameModel *) modelFromDataCore;

// Initiates an instance of the AldGameModel class with the specified player portraits as well as the specified number of cards.
// The game will be initiated automatically with these parameters.
-(id)              initWithNumberOfCards: (NSUInteger)numberOfCards playersWithPortraits: (NSArray *)playerPortraitPaths;

// Restores an instance of the AldGameModel class from the specified model entity. The game is restored in its entirety and no
// further selectors must be invoked to resume the game.
-(id)              initWithEntity: (AldGameEntity *)modelEntity;

#pragma mark - Game logic

// Initializes the player array with the specified portrait paths.
-(void)            preparePlayers: (NSArray *)playerPortraitPaths;

// Initializes cards for the current game, picking randomly from the collection of available tengwar symbols.
-(void)            prepareCards;

// Retrieves the AldCardData object for the card at the specified index.
-(AldCardData *)   dataForIndex: (NSUInteger)index;

// Flips the specified cards to the back, and returns YES or NO if the two cards match. The indexes array must contain
// as many card indexes as is specified by the kAldNumberOfSimultaneousCardSelections constant.
-(BOOL)            flipCards: (NSUInteger *)indexes;

// Retrieves the previous player data
-(AldPlayerData *) previousPlayer;

// Retrieves the current player data
-(AldPlayerData *) currentPlayer;

// Retrieves the player data for the player currently in the lead
-(AldPlayerData *) playerInTheLead;

// Switches to the next player.
-(void)            switchPlayers;

// Finishes the game with the winning player name as specified. The specified name will be used for storing high-
// score.
-(BOOL)            finishWithWinningPlayerName: (NSString *)playerName;

#pragma mark - Persistence

// Saves the model using the AldDataCore.
-(void)            persist;

// Saves thec urrent highscore using the AldDataCore.
-(void)            persistHighscore: (NSUInteger)score forPlayerName: (NSString *)playerName;

// Restores the model from entity  specified during initialization. This method must never be invoked manually.
-(void)            loadFromEntity;

@end
