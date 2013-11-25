//
//  AldGameModel.h
//  leowic-3_Labb4
//
//  Created by Leonard Wickmark on 17/11/13.
//  Copyright (c) 2013 LTU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AldCardData.h"

@interface AldGameModel : NSObject

@property(nonatomic) NSUInteger cardsPerRow;

-(id) initWithNumberOfCards: (NSUInteger)numberOfCards;
-(void) prepareCards;
-(AldCardData *) dataForIndex: (NSUInteger)index;
-(NSArray *) collectVariants: (NSUInteger)numberOfVariants;

@end
