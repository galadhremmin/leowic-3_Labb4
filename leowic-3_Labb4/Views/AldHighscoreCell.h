//
//  AldHighscoreCell.h
//  leowic-3_Labb4
//
//  Created by Leonard Wickmark on 05/12/13.
//  Copyright (c) 2013 LTU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AldHighscoreCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *highscoreDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *highscorePlayerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *highscoreScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *highscoreRowLabel;
@end
