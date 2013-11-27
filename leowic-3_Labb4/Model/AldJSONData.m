//
//  AldJSONData.m
//  leowic-3_Labb4
//
//  Created by Leonard Wickmark on 27/11/13.
//  Copyright (c) 2013 LTU. All rights reserved.
//

#import "AldJSONData.h"

@implementation AldJSONData

-(id) initFromSerialization: (NSDictionary *)jsonData
{
    self = [super init];
    if (self) {
        
        for (NSString *key in [jsonData allKeys]) {
            [self setValue:[jsonData objectForKey:key] forKeyPath:key];
        }
        
    }
    return self;
}

-(NSDictionary *)serialize
{
    return nil;
}

@end
