//
//  AldPlayerData.m
//  leowic-3_Labb4
//
//  Created by Leonard Wickmark on 27/11/13.
//  Copyright (c) 2013 LTU. All rights reserved.
//

#import "AldPlayerData.h"

@implementation AldPlayerData

-(void) scorePoints: (NSUInteger)points
{
    points += _score;
    [self setScore: points];
}

@end
