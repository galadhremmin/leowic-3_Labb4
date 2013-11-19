//
//  AldCardSideView.h
//  leowic-3_Labb4
//
//  Created by Leonard Wickmark on 17/11/13.
//  Copyright (c) 2013 LTU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AldCardSidesViewContainer.h"

@interface AldCardSideView : UIImageView

@property(nonatomic, weak) AldCardSidesViewContainer *associatedCard;

-(id)   initWithOrigin: (CGPoint)origin associatedWithCard: (AldCardSidesViewContainer *)card;
-(void) initStyles;
-(void) initContents;
-(void) deselect;
-(void) select;

@end
