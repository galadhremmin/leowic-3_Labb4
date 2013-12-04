//
//  AldHighscoreEntity.h
//  leowic-3_Labb4
//
//  Created by Leonard Wickmark on 03/12/13.
//  Copyright (c) 2013 LTU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface AldHighscoreEntity : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * highscoreID;
@property (nonatomic, retain) NSString * playerName;
@property (nonatomic, retain) NSNumber * score;

@end
