//
//  AldCardViewCollection.h
//  leowic-3_Labb4
//
//  Created by Leonard Wickmark on 17/11/13.
//  Copyright (c) 2013 LTU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AldCardView : NSObject

+(NSUInteger) cardSquareSize;

@property(nonatomic, readonly)         NSUInteger index;
@property(nonatomic, strong, readonly) UIView     *frontView;
@property(nonatomic, strong, readonly) UIView     *backView;

-(id)      initWithIndex: (NSUInteger)index;
-(UIView*) oppositeView: (UIView *)view;

@end
