//
//  AldCardViewCollection.m
//  leowic-3_Labb4
//
//  Created by Leonard Wickmark on 17/11/13.
//  Copyright (c) 2013 LTU. All rights reserved.
//

#import "AldCardView.h"
#import "AldCardFrontView.h"
#import "AldCardBackView.h"

@interface AldCardView()

@property(nonatomic, strong) UIView *frontView;
@property(nonatomic, strong) UIView *backView;

@end

@implementation AldCardView

+(NSUInteger) cardSquareSize
{
    return 200;
}

-(id) initWithIndex: (NSUInteger)index
{
    self = [super init];
    if (self) {
        CGPoint origin = CGPointMake(0, 0);
        
        _index = index;
        _frontView = [[AldCardFrontView alloc] initWithOrigin:origin associatedWithCard:self];
        _backView  = [[AldCardBackView  alloc] initWithOrigin:origin associatedWithCard:self];
    }
    
    return self;
}

-(UIView*) oppositeView: (UIView *)view
{
    if (view == _backView) {
        return _frontView;
    }
    
    if (view == _frontView) {
        return _backView;
    }
    
    return nil;
}

@end
