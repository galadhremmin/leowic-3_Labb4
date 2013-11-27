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

@property(nonatomic) NSMutableArray  *map;
@property(nonatomic) NSUInteger       currentPlayerIndex;
@property(nonatomic, strong) NSArray *players;

@end

@implementation AldGameModel

-(id) initWithNumberOfCards: (NSUInteger)numberOfCards players: (NSUInteger)numberOfPlayers
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
        
        [self preparePlayers:numberOfPlayers];
        [self prepareCards];
    }
    
    return self;
}

-(void) preparePlayers: (NSUInteger)numberOfPlayers
{
    NSMutableArray *players = [[NSMutableArray alloc] initWithCapacity:numberOfPlayers];
    
    for (int i = 0; i < numberOfPlayers; i += 1) {
        AldPlayerData *player = [[AldPlayerData alloc] init];
        [players addObject:player];
    }
    
    [self setPlayers:players];
    [self setCurrentPlayerIndex:0];
}

-(void) prepareCards
{
    // Calculate number of cards which will be in play. This is the square of the number of
    // cards per row.
    NSUInteger totalNumberOfCards = _cardsPerRow * _cardsPerRow;
    
    // Declare a few utility variables.
    NSUInteger i, n, iterations, i0, i1;

    // Initialize the map with enough capacity to hold all cards.
    if (_map == nil) {
        _map = [[NSMutableArray alloc] initWithCapacity:totalNumberOfCards];
    } else {
        [_map removeAllObjects];
    }
    
    // From the application's configuration settings, acquire enough card variants to
    // populate the full map. This is (of course) the number of cards per row times two.
    NSArray *tengwarSymbols = [self collectVariants:_cardsPerRow * 2];
    
    // Adds the cards to the map sequentially, in the given order.
    for (i = 0, n = 1; i < totalNumberOfCards; i += 1) {
        AldCardData *cardData = [tengwarSymbols objectAtIndex:n - 1];
        [_map insertObject:cardData atIndex:i];
        
        if (i > 0 && i % 2) {
            n += 1;
        }
    }
    
    // Scramble the cards a bit, as they are in order.
    iterations = totalNumberOfCards * 5; // number of iterations, the higher the better randomness!
    for (i = 0; i < iterations; i += 1) {
        
        i0 = i % totalNumberOfCards;
        i1 = arc4random_uniform(totalNumberOfCards);
        
        if (i0 != i1) {
            [_map exchangeObjectAtIndex:i1 withObjectAtIndex:i0];
        }
    }
    
    for (i = 0; i < totalNumberOfCards; i += 1) {
        NSLog(@"%d: %@", i + 1, [[_map objectAtIndex:i] title]);
    }
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

-(AldPlayerData *)currentPlayer
{
    return [_players objectAtIndex:_currentPlayerIndex];
}

-(void) switchPlayers
{
    NSUInteger currentPlayer = _currentPlayerIndex + 1;
    if (currentPlayer >= _players.count) {
        currentPlayer = 0;
    }
    
    [self setCurrentPlayerIndex:currentPlayer];
}

-(void) collectCards: (NSUInteger)index
{
    if (index >= _map.count) {
        return;
    }
    
    AldCardData *card = [_map objectAtIndex:index];
    card.collected = YES;
    
    [[self currentPlayer] scorePoints:_map.count];
}

@end
