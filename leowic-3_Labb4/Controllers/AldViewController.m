//
//  AldViewController.m
//  leowic-3_Labb4
//
//  Created by Leonard Wickmark on 12/11/13.
//  Copyright (c) 2013 LTU. All rights reserved.
//

#import "AldViewController.h"

@implementation AldViewController

-(void) viewDidLoad
{
    [super viewDidLoad];
    
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://apod.nasa.gov/apod/image/1102/rosette_lula_1700.jpg"]]];
    
    UIImageView *subview = [[UIImageView alloc] initWithImage:image];

    _scrollView.autoresizesSubviews = NO;
    _scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    [_scrollView addSubview:subview];
    _scrollView.contentSize = image.size;
    _scrollView.maximumZoomScale = 4;
    _scrollView.minimumZoomScale = 1;
}

-(UIView *) viewForZoomingInScrollView: (UIScrollView *)scrollView
{
    return [scrollView.subviews objectAtIndex:0];
}

@end
