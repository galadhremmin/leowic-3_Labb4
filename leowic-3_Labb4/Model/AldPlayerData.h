//
//  AldPlayerData.h
//  leowic-3_Labb4
//
//  Created by Leonard Wickmark on 27/11/13.
//  Copyright (c) 2013 LTU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AldPlayerData : NSObject

@property(nonatomic)         NSUInteger  ID;
@property(nonatomic)         NSInteger   score;
@property(strong, nonatomic) NSString   *portraitPath;

-(id)  initWithID: (NSUInteger)ID score: (NSInteger)score portrait: (NSString *)portraitPath;
-(void) scorePoints: (NSInteger)points;

@end
