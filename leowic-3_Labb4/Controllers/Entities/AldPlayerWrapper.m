//
//  AldPlayerWrapper.m
//  leowic-3_Labb4
//
//  Created by Leonard Wickmark on 27/11/13.
//  Copyright (c) 2013 LTU. All rights reserved.
//

#import "AldPlayerWrapper.h"

@implementation AldPlayerWrapper

-(id) initWithID: (NSUInteger)ID portraitPath: (NSString *)portraitPath pointsLabel: (UILabel *)label
{
    self = [super init];
    if (self) {
        _ID = ID;
        _portraitPath = portraitPath;
        _portraitView = nil;
        _pointsLabel = label;
    }
    return self;
}

@end
