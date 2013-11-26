//
//  AldPlayerData.m
//  leowic-3_Labb4
//
//  Created by Leonard Wickmark on 26/11/13.
//  Copyright (c) 2013 LTU. All rights reserved.
//

#import "AldPlayerData.h"

@implementation AldPlayerData

-(id) initWithName: (NSString *)name portrait: (UIImage *)image
{
    self = [super init];
    if (self) {
        _name = name;
        _portrait = image;
    }
    
    return self;
}

@end
