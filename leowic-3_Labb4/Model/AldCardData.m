//
//  AldCardData.m
//  leowic-3_Labb4
//
//  Created by Leonard Wickmark on 25/11/13.
//  Copyright (c) 2013 LTU. All rights reserved.
//

#import "AldCardData.h"

@implementation AldCardData

-(id) initWithTitle: (NSString *)title description: (NSString *)description
{
    self = [super init];
    if (self) {
        _title = title;
        _description = description;
    }
    
    return self;
}

-(NSUInteger) hash
{
    return [_title hash];
}

@end
