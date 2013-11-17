//
//  AldGameModel.h
//  leowic-3_Labb4
//
//  Created by Leonard Wickmark on 17/11/13.
//  Copyright (c) 2013 LTU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AldGameModel : NSObject

@property(nonatomic) NSUInteger mapSize;

-(id)         initWithVariants: (NSUInteger)variants;
-(void)       generateMap;
-(NSUInteger) variationForIndex: (NSUInteger)index;

@end
