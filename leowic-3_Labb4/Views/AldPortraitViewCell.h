//
//  AldPortraitViewCell.h
//  leowic-3_Labb4
//
//  Created by Leonard Wickmark on 30/11/13.
//  Copyright (c) 2013 LTU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AldPortraitViewCell : UICollectionViewCell

@property(nonatomic, strong) IBOutlet UIImageView *imageView;
@property(nonatomic, strong)          NSString    *portraitImagePath;

-(void) loadPortraitImage;

@end
