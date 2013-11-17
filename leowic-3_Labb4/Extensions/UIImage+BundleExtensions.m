//
//  UIImage+BundleExtensions.m
//  leowic-3_Labb4
//
//  Created by Leonard Wickmark on 17/11/13.
//  Copyright (c) 2013 LTU. All rights reserved.
//

#import "UIImage+BundleExtensions.h"

@implementation UIImage (BundleExtensions)

+(UIImage *) imageFromBundle: (NSString *)fileName
{
    if (fileName == nil) {
        return nil;
    }
    
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString *imagePath    = [resourcePath stringByAppendingPathComponent:fileName];
    UIImage *image         = [UIImage imageWithContentsOfFile:imagePath];
    
    return image;
}

@end
