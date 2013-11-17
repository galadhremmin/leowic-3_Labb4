//
//  AldGameModel.m
//  leowic-3_Labb4
//
//  Created by Leonard Wickmark on 17/11/13.
//  Copyright (c) 2013 LTU. All rights reserved.
//

#import "AldGameModel.h"

@interface AldGameModel ()

@property(nonatomic) NSMutableArray *map;

@end

@implementation AldGameModel

-(id) initWithVariants: (NSUInteger)variants
{
    self = [super init];
    if (self) {
        _mapSize = (NSUInteger) sqrt(variants);
        [self generateMap];
    }
    
    return self;
}

-(void) generateMap
{
    NSUInteger length = _mapSize * _mapSize, i, n, iterations, i0, i1;

    _map = [[NSMutableArray alloc] initWithCapacity:length];
    for (i = 0, n = 1; i < length; i += 1) {
        [_map insertObject:[NSNumber numberWithInt:n] atIndex:i];
        
        if (i > 0 && i % 2) {
            n += 1;
        }
    }
    
    iterations = length * 5; // number of iterations, the higher the better randomness!
    for (i = 0; i < length; i += 1) {
        
        i0 = i % length;
        i1 = arc4random() % length;
        
        if (i0 != i1) {
            [_map exchangeObjectAtIndex:i1 withObjectAtIndex:i0];
        }
        
    }
}

-(NSUInteger) variationForIndex: (NSUInteger)index
{
    if (_map == nil || index >= [_map count]) {
        return -1;
    }
    
    return [[_map objectAtIndex:index] integerValue];
}

@end
