//
//  AldViewController.h
//  leowic-3_Labb4
//
//  Created by Leonard Wickmark on 12/11/13.
//  Copyright (c) 2013 LTU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AldGameModel.h"
#import "AldCardSideView.h"
#import "AldWillOWispView.h"

@interface AldViewController : UIViewController<UIScrollViewDelegate>

@property (weak, nonatomic)   IBOutlet UIScrollView     *scrollView;
@property (weak, nonatomic)   IBOutlet UIImageView      *firstPlayerView;
@property (weak, nonatomic)   IBOutlet UIImageView      *secondPlayerView;
@property (weak, nonatomic)   IBOutlet AldWillOWispView *willOWisp;
@property (weak, nonatomic)            UIView           *subview;
@property (strong, nonatomic)          AldGameModel     *model;
@property (strong, atomic)             NSArray          *players;

-(void) createPlayersWithPortraits: (NSArray *)portraitPaths;

@end
