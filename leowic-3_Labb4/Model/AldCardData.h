//
//  AldCardData.h
//  leowic-3_Labb4
//
//  Created by Leonard Wickmark on 25/11/13.
//  Copyright (c) 2013 LTU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AldCardData : NSObject

@property(readonly, copy, nonatomic) NSString *title;
@property(readonly, copy, nonatomic) NSString *description;

-(id) initWithTitle: (NSString *)title description: (NSString *)description;
-(NSUInteger) hash;
@end
