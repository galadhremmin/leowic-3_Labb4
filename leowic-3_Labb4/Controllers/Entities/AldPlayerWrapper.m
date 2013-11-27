//
//  AldPlayerWrapper.m
//  leowic-3_Labb4
//
//  Created by Leonard Wickmark on 27/11/13.
//  Copyright (c) 2013 LTU. All rights reserved.
//

#import "AldPlayerWrapper.h"

@implementation AldPlayerWrapper

-(id) initWithIndex: (NSUInteger)index portrait: (UIImage *)portrait
{
    self = [super init];
    if (self) {
        _index = index;
        _portrait = portrait;
        _portraitView = nil;
    }
    return self;
}

@end
