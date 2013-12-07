//
//  AldGameModel.m
//  leowic-3_Labb4
//
//  Created by Leonard Wickmark on 17/11/13.
//  Copyright (c) 2013 LTU. All rights reserved.
//

#import "AldGameModel.h"
#import "AldPlayerData.h"

@interface AldGameModel ()

@property(nonatomic)         NSUInteger       currentPlayerIndex;
@property(nonatomic)         NSUInteger       cardsLeftToFlip;
@property(nonatomic, strong) NSMutableArray  *map;
@property(nonatomic, strong) AldGameEntity   *modelEntity;

@end

@implementation AldGameModel

#pragma mark - Initialization

+(AldGameModel *) modelFromDataCore
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    AldDataCore *core = [AldDataCore defaultCore];
    
    NSEntityDescription *gameEntity = [NSEntityDescription entityForName:kAldDataCoreGameEntityName inManagedObjectContext:core.managedObjectContext];
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"dateBegun" ascending:NO];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"cardsLeftToFlip > 0"];
    
    fetchRequest.entity = gameEntity;
    fetchRequest.predicate = predicate;
    fetchRequest.sortDescriptors = @[sortDescriptor];
    fetchRequest.fetchLimit = 1;
    
    NSError *error = nil;
    NSArray *entities = [core.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (entities == nil || entities.count < 1) {
        return nil;
    }
    
    AldGameEntity *entity = (AldGameEntity *) [entities objectAtIndex:0];
    return [[AldGameModel alloc] initWithEntity:entity];
}

-(id) initWithNumberOfCards: (NSUInteger)numberOfCards playersWithPortraits: (NSArray *)playerPortraitPaths
{
    self = [super init];
    if (self) {
        if (numberOfCards < 1) {
            [NSException raise:@"Erroneous number of cards." format:@"%d is not a valid number of cards.", numberOfCards];
        }
        
        NSUInteger cardsPerRow = (NSUInteger) sqrt(numberOfCards);
        if (cardsPerRow != sqrt(numberOfCards)) {
            [NSException raise:@"Erroneous number of cards." format:@"The number of cards must be an even square! %d is not.", numberOfCards];
        }
        
        if (cardsPerRow % 2) {
            [NSException raise:@"Erroneous number of cards." format:@"The number of cards must be an even square! %d (%d*%d) is not.", numberOfCards, cardsPerRow, cardsPerRow];
        }
        
        _cardsPerRow = cardsPerRow;
        
        [self preparePlayers:playerPortraitPaths];
        [self prepareCards];
    }
    
    return self;
}

-(id) initWithEntity: (AldGameEntity *)modelEntity
{
    self = [super init];
    if (self) {
        _modelEntity = modelEntity;
        [self loadFromEntity];
    }
    return self;
}

#pragma mark - Game logic

-(void) preparePlayers: (NSArray *)playerPortraitPaths
{
    if (playerPortraitPaths == nil || playerPortraitPaths.count < 1) {
        [NSException raise:@"Erroneous number of players." format:@"At least one player portrait has to be specified"];
    }
    
    NSMutableArray *players = [[NSMutableArray alloc] initWithCapacity:playerPortraitPaths.count];
    NSUInteger playerID = 1;
    
    for (NSString *portraitPath in playerPortraitPaths) {
        AldPlayerData *player = [[AldPlayerData alloc] initWithID:playerID score:0 portrait:portraitPath];
        [players addObject:player];
        
        playerID += 1;
    }
    
    _players = players;
    _currentPlayerIndex = 0;
}

-(void) prepareCards
{    
    // Calculate number of cards which will be in play. This is the square of the number of
    // cards per row.
    _cardsLeftToFlip = pow(_cardsPerRow, 2);
    _pointMagnitude = pow(_cardsLeftToFlip, 2) * 0.5;
    
    // Declare a few utility variables.
    NSUInteger i, n, iterations, i0, i1;

    // Initialize the map with enough capacity to hold all cards.
    if (_map == nil) {
        _map = [[NSMutableArray alloc] initWithCapacity:_cardsLeftToFlip];
    } else {
        [_map removeAllObjects];
    }
    
    // From the application's configuration settings, acquire enough card variants to
    // populate the full map. This is (of course) the number of cards per row times two.
    NSArray *tengwarSymbols = [self collectVariants:_cardsLeftToFlip * 0.5];
    
    // Adds the cards to the map sequentially, in the given order.
    for (i = 0, n = 0; i < _cardsLeftToFlip; n += 1) {
        NSUInteger cards =i + kAldNumberOfSimultaneousCardSelections;
        for (; i < cards; i += 1) {
            AldCardData *cardData = [tengwarSymbols objectAtIndex:n];
            [_map insertObject:cardData atIndex:i];
        }
    }
    
    // Scramble the cards a bit, as they are in order.
    iterations = _cardsLeftToFlip * 5; // number of iterations, the higher the better randomness!
    for (i = 0; i < iterations; i += 1) {
        
        i0 = i % _cardsLeftToFlip;
        i1 = arc4random_uniform(_cardsLeftToFlip);
        
        if (i0 != i1) {
            [_map exchangeObjectAtIndex:i1 withObjectAtIndex:i0];
        }
    }
    
#if DEBUG
    NSMutableString *row = [NSMutableString string];
    i = 1;
    for (AldCardData *card in _map) {
        [row appendFormat:@"%@ ", card.title];
        
        if (i % _cardsPerRow == 0) {
            NSLog(@"%@", row);
            [row setString:@""];
        }
        i += 1;
    }
    
#endif
    
    // Deassociate the model entity with the model, if there is one. This will force
    // the persist method to save a new instance of the game model, in contrast to
    // just updating the existing.
    _modelEntity = nil;
    
    // Persist the game.
    [self persist];
}


-(AldCardData *) dataForIndex: (NSUInteger)index
{
    if (_map == nil || index >= [_map count]) {
        return nil;
    }
    
    return [_map objectAtIndex:index];
}

-(NSArray *) collectVariants: (NSUInteger)numberOfVariants
{
    // Acquire all supported tengwar symbols from the default info dictionary
    NSDictionary *tengwar = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"Tengwar symbols"];
    NSArray *tengwarSymbols = [tengwar allKeys];
    NSUInteger availableVariants = tengwarSymbols.count;
    
    if (availableVariants < numberOfVariants) {
        [NSException raise:@"Too many variations!" format:@"%d variations are simply too many. This application supports %d variations.", numberOfVariants, tengwarSymbols.count];
        return nil;
    }
    
    // Randomize the picking if the number of variants is not equal to the number of available
    // variants, at which point they are all taken for this purpose.
    NSUInteger *usedVariants = nil;
    BOOL randomized = NO;
    if (availableVariants != numberOfVariants) {
        usedVariants = (NSUInteger *) calloc(sizeof(NSUInteger), numberOfVariants);
        randomized = YES;
    }
    
    NSMutableArray *collection = nil;
    @try {
        collection = [NSMutableArray arrayWithCapacity:numberOfVariants];
        NSUInteger index = 0;
        NSString *tengwarSymbol;
        AldCardData *cardData;
        
        // Stir the randomizer by reading from /dev/urandom.
        arc4random_stir();
        do {
            
            // Increment the index or randomize it, depending on the instruction.
            if (randomized) {
                index = arc4random_uniform(availableVariants);
            } else {
                index += 1;
            }
            
            // In case randomization is activated, skip card variants already added.
            if (randomized && usedVariants[index]) {
                continue;
            }
            
            // The variant is used -- flag it so it won't be chosen again
            if (randomized) {
                usedVariants[index] = 1;
            }
            
            // Create the card data for the item at the specified index.
            tengwarSymbol = [tengwarSymbols objectAtIndex:index];
            cardData      = [[AldCardData alloc] initWithTitle:tengwarSymbol description:[tengwar objectForKey:tengwarSymbol]];
            
            [collection addObject:cardData];
            
        } while (collection.count < numberOfVariants);
    }
    @catch (NSException *exception) {
        // just throw the exception, as it's the @finally we want.
        @throw;
    }
    @finally {
        free(usedVariants);
        usedVariants = nil;
    }
    
    return collection;
}

-(BOOL) flipCards: (NSUInteger *)indexes
{
    if (indexes == nil) {
        return NO;
    }
    
    NSUInteger variant = 0;
    NSUInteger i;
    BOOL matches = YES;
    for (i = 0; i < kAldNumberOfSimultaneousCardSelections; i += 1) {
        AldCardData *data = [self dataForIndex:indexes[i]];
        
        // collect cards can't be flipped again
        if (data.collected) {
            return false;
        }
        
        if (variant < 1) {
            variant = data.hash;
        } else if (variant != data.hash) {
            matches = NO;
            break;
        }
    }
    
    AldPlayerData *player = [self currentPlayer];
    NSUInteger magnitude = _pointMagnitude * _players.count;
    
    if (matches) {
        [player scorePoints:magnitude];
        _cardsLeftToFlip -= kAldNumberOfSimultaneousCardSelections;
        
        // Assign the collected state to the cards associated with this instruction
        for (i = 0; i < kAldNumberOfSimultaneousCardSelections; i += 1) {
            AldCardData *data = [self dataForIndex:indexes[i]];
            data.collected = YES;
        }
        
    } else {
        NSInteger penalty = magnitude * 0.25; // Penalize 1/4 of the number of items
        [player scorePoints:-penalty];
    }
    
    [self switchPlayers];
    [self persist];
    
    return matches;
}

-(AldPlayerData *) previousPlayer
{
    NSUInteger index = _currentPlayerIndex;
    if (index < 1) {
        index = _players.count - 1;
    } else {
        index -= 1;
    }
    
    return [_players objectAtIndex:index];
}

-(AldPlayerData *) currentPlayer
{
    return [_players objectAtIndex:_currentPlayerIndex];
}

-(AldPlayerData *) playerInTheLead
{
    AldPlayerData *leadingPlayer = nil;
    for (AldPlayerData *player in _players) {
        if (leadingPlayer == nil) {
            leadingPlayer = player;
        } else if (player.score == leadingPlayer.score) {
            return nil; // draw!
        } else if (player.score > leadingPlayer.score) {
            leadingPlayer = player;
        }
    }
    
    return leadingPlayer;
}

-(void) switchPlayers
{
    NSUInteger currentPlayer = _currentPlayerIndex + 1;
    if (currentPlayer >= _players.count) {
        currentPlayer = 0;
        _rounds += 1;
        
        if (_pointMagnitude > 1) {
            _pointMagnitude -= 1;
        }
    }
    
    [self setCurrentPlayerIndex:currentPlayer];
}

-(BOOL) finishWithWinningPlayerName: (NSString *)playerName
{
    if (_cardsLeftToFlip > 0) {
        [NSException raise:@"Can't finish the current game!" format:@"There are cards left to flip."];
    }
    
    AldPlayerData *winningPlayer = [self playerInTheLead];
    
    BOOL isHighscore = NO;
    if (winningPlayer != nil) {
        isHighscore = [self isHighscore:winningPlayer.score];
        
        // Save a highscore record, regardless if it's a new highscore or not, as it might be interesting to see
        // one's performance history regardless.
        [self persistHighscore:winningPlayer.score forPlayerName:playerName];
    }
    
    // Clean up the database - this information is no longer required
    [self persist];
    
    return isHighscore;
}

#pragma mark - Persistence

-(void) persist
{
    // Do not persist the game model if there are no cards left to flip, as the game is
    // finished.
    if (_cardsLeftToFlip < 1) {
        return;
    }
    
    NSUInteger i;
    
    AldDataCore *core = [AldDataCore defaultCore];
    AldGameEntity *gameEntity = _modelEntity;
    
    // If there is no game entity associated with this model, this is a new game which
    // should be inserted in the database.
    if (gameEntity == nil) {
        gameEntity = [NSEntityDescription insertNewObjectForEntityForName:kAldDataCoreGameEntityName inManagedObjectContext:core.managedObjectContext];
        
        gameEntity.cardsPerRow = [NSNumber numberWithUnsignedInteger:_cardsPerRow];
        gameEntity.dateBegun   = [NSDate date];
    }
    
    // Always update the current player, as it changes with every round.
    gameEntity.currentPlayerID = [NSNumber numberWithUnsignedInteger:_currentPlayerIndex];
    gameEntity.cardsLeftToFlip = [NSNumber numberWithUnsignedInteger:_cardsLeftToFlip];
    
    NSArray *entities = [gameEntity.cards allObjects];
    BOOL newEntity = NO;
    for (i = 0; i < _cardsLeftToFlip; i += 1) {
        AldGameCardEntity *cardEntity = nil;
        newEntity = NO;
        
        if (entities.count > i) {
            cardEntity = [entities objectAtIndex:i];
        }
        
        // If the entity is nil, it doesn't exist. Create one for this card.
        if (cardEntity == nil) {
            cardEntity = [NSEntityDescription insertNewObjectForEntityForName:kAldDataCoreGameCardEntityName inManagedObjectContext:core.managedObjectContext];
            newEntity = YES;
        }
        
        AldCardData *cardData = [_map objectAtIndex:i];
        cardEntity.cardTitle       = cardData.title;
        cardEntity.cardDescription = cardData.description;
        cardEntity.collected       = [NSNumber numberWithBool:cardData.collected];
        cardEntity.index           = [NSNumber numberWithUnsignedInteger:i];
        
        if (newEntity) {
            [gameEntity addCardsObject:cardEntity];
        }
    }
    
    entities = [gameEntity.players allObjects];
    for (i = 0; i < _players.count; i += 1) {
        AldPlayerEntity *playerEntity = nil;
        newEntity = NO;
        
        if (entities.count > 1) {
            playerEntity = [entities objectAtIndex:i];
        }
        
        // If the player entity is nil, it doesn't exist. Create one for this player.
        if (playerEntity == nil) {
            playerEntity = [NSEntityDescription insertNewObjectForEntityForName:kAldDataCorePlayerEntityName inManagedObjectContext:core.managedObjectContext];
            newEntity = YES;
        }
        
        AldPlayerData *playerData = [_players objectAtIndex:i];
        playerEntity.index    = [NSNumber numberWithUnsignedInteger:i];
        playerEntity.score    = [NSNumber numberWithUnsignedInteger:playerData.score];
        playerEntity.portrait = playerData.portraitPath;
        
        if (newEntity) {
            [gameEntity addPlayersObject:playerEntity];
        }
    }
    
    [core saveChanges];
    
    // Store a reference to the game entity, so that the next time this selector is invoked,
    // the entity is updated instead.
    _modelEntity = gameEntity;
}

-(BOOL) isHighscore: (NSUInteger)score
{
    AldDataCore *core = [AldDataCore defaultCore];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:kAldDataCoreHighscoreEntityName    inManagedObjectContext:core.managedObjectContext];
    [request setEntity:entity];
    
    // Specify that the request should return dictionaries.
    [request setResultType:NSDictionaryResultType];
    
    // Create an expression for the key path.
    NSExpression *keyPathExpression = [NSExpression expressionForKeyPath:@"score"];
    
    // Create an expression to represent the minimum value at the key path 'creationDate'
    NSExpression *maxExpression = [NSExpression expressionForFunction:@"max:" arguments:[NSArray arrayWithObject:keyPathExpression]];
    
    // Create an expression description using the minExpression and returning a date.
    NSExpressionDescription *expressionDescription = [[NSExpressionDescription alloc] init];
    
    // The name is the key that will be used in the dictionary for the return value.
    [expressionDescription setName:@"maxScore"];
    [expressionDescription setExpression:maxExpression];
    [expressionDescription setExpressionResultType:NSInteger64AttributeType];
    
    // Set the request's properties to fetch just the property represented by the expressions.
    [request setPropertiesToFetch:[NSArray arrayWithObject:expressionDescription]];
    
    NSError *error = nil;
    NSArray *objects = [core.managedObjectContext executeFetchRequest:request error:&error];
    
    if (objects == nil || objects.count < 1) {
        return YES;
    }
    
    return [[[objects firstObject] valueForKey:@"maxScore"] unsignedIntegerValue] < score;
}

-(void) persistHighscore: (NSUInteger)score forPlayerName: (NSString *)playerName
{
    AldDataCore *core = [AldDataCore defaultCore];
    AldHighscoreEntity *highscoreEntity = [NSEntityDescription insertNewObjectForEntityForName:kAldDataCoreHighscoreEntityName inManagedObjectContext:core.managedObjectContext];
    
    highscoreEntity.score = [NSNumber numberWithUnsignedInteger:score];
    highscoreEntity.playerName = playerName;
    highscoreEntity.date = [NSDate date];
    
    [core saveChanges];
}

-(void) loadFromEntity
{
    if (_modelEntity == nil) {
        [NSException raise:@"Failed to load from entity." format:@"No entity appointed! Make sure to initialize the instance of the data model using the initWithEntity selector."];
    }
    
    AldGameEntity *data = _modelEntity;
    
    // Restore basic game logic
    _currentPlayerIndex = [data.currentPlayerID unsignedIntegerValue];
    _rounds = [data.rounds unsignedIntegerValue];
    
    // Restore the cards (the "map")
    _cardsPerRow = [data.cardsPerRow unsignedIntegerValue];
    _cardsLeftToFlip = [data.cardsLeftToFlip unsignedIntegerValue];
    _map = [[NSMutableArray alloc] initWithCapacity:_cardsPerRow * _cardsPerRow];

    // Fill the array with null, to be sure that the space is allocated
    NSUInteger i = 0;
    for ( ; i < data.cards.count; i += 1) {
        [_map addObject:[NSNull null]];
    }
    
    for (AldGameCardEntity *cardEntity in data.cards) {
        AldCardData *cardData = [[AldCardData alloc] initWithTitle:cardEntity.cardTitle description:cardEntity.cardDescription];
        cardData.collected = [cardEntity.collected boolValue];
        
        [_map replaceObjectAtIndex:[cardEntity.index unsignedIntegerValue] withObject:cardData];
    }
    
    // restore the points rewarded next round
    _pointMagnitude = pow(_cardsLeftToFlip, 2);
    if (_rounds > _pointMagnitude) {
        _pointMagnitude = 1;
    }
    
    // Restore the players
    NSMutableArray *players;
    
    _players = players = [[NSMutableArray alloc] initWithCapacity:data.players.count];
    
    for (i = 0; i < data.players.count; i += 1) {
        [players addObject:[NSNull null]];
    }
    
    for (AldPlayerEntity *playerEntity in data.players) {
        AldPlayerData *playerData = [[AldPlayerData alloc] initWithID:[playerEntity.index unsignedIntegerValue] + 1 score:[playerEntity.score unsignedIntegerValue] portrait:playerEntity.portrait];
        
        [players replaceObjectAtIndex:[playerEntity.index unsignedIntegerValue] withObject:playerData];
    }
}

@end
