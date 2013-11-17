//
//  AldCardSideView.h
//  leowic-3_Labb4
//
//  Created by Leonard Wickmark on 17/11/13.
//  Copyright (c) 2013 LTU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AldCardSideViewContainer.h"

@interface AldCardSideView : UIImageView

@property(nonatomic, weak) AldCardSideViewContainer *parentCard;

-(id)   initWithOrigin: (CGPoint)origin associatedWithCard: (AldCardSideViewContainer *)card;
-(void) initStyles;
-(void) initContents;

@end
