//
//  AldViewController.h
//  leowic-3_Labb4
//
//  Created by Leonard Wickmark on 12/11/13.
//  Copyright (c) 2013 LTU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AldViewController : UIViewController<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) UIView *subview;

@end
