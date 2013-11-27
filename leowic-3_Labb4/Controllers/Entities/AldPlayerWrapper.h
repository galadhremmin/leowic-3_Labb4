//
//  AldPlayerWrapper.h
//  leowic-3_Labb4
//
//  Created by Leonard Wickmark on 27/11/13.
//  Copyright (c) 2013 LTU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AldPlayerWrapper : NSObject

@property(nonatomic, strong) UIImage     *portrait;
@property(nonatomic, weak)   UIImageView *portraitView;
@property(nonatomic)         NSUInteger   index;

-(id) initWithIndex: (NSUInteger)index portrait: (UIImage *)portrait;

@end
