//
//  AldPlayerWrapper.h
//  leowic-3_Labb4
//
//  Created by Leonard Wickmark on 27/11/13.
//  Copyright (c) 2013 LTU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AldPlayerWrapper : NSObject

@property(nonatomic, strong) NSString    *portraitPath;
@property(nonatomic, weak)   UIImageView *portraitView;
@property(nonatomic, weak)   UILabel     *pointsLabel;
@property(nonatomic)         NSUInteger   ID;

-(id) initWithID: (NSUInteger)ID portraitPath: (NSString *)portraitPath pointsLabel: (UILabel *)label;

@end
