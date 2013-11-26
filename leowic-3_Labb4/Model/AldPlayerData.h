//
//  AldPlayerData.h
//  leowic-3_Labb4
//
//  Created by Leonard Wickmark on 26/11/13.
//  Copyright (c) 2013 LTU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AldPlayerData : NSObject

@property(nonatomic, copy) NSString *name;
@property(nonatomic, strong) UIImage *portrait;

-(id) initWithName: (NSString *)name portrait: (UIImage *)image;

@end
