//
//  AldViewController.h
//  leowic-3_Labb4
//
//  Created by Leonard Wickmark on 12/11/13.
//  Copyright (c) 2013 LTU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "AldGameModel.h"
#import "AldCardSideView.h"
#import "AldWillOWispView.h"

@interface AldGameViewController : UIViewController<UIScrollViewDelegate, UIAlertViewDelegate>

@property (weak, nonatomic)   IBOutlet UIScrollView     *scrollView;
@property (weak, nonatomic)   IBOutlet UIImageView      *player1View;
@property (weak, nonatomic)   IBOutlet UIImageView      *player2View;
@property (weak, nonatomic)   IBOutlet UIImageView      *player1FrameView;
@property (weak, nonatomic)   IBOutlet UIImageView      *player2FrameView;
@property (weak, nonatomic)   IBOutlet AldWillOWispView *willOWisp;
@property (strong, nonatomic)          AldGameModel     *model;
@property (strong, nonatomic)          NSArray          *playerPortraitPaths;
@property (strong, atomic)             NSArray          *players;
@property (strong, nonatomic)          AVAudioPlayer    *backgroundMusicPlayer;

@end
