//
//  AldPlayerSelectionViewController.m
//  leowic-3_Labb4
//
//  Created by Leonard Wickmark on 26/11/13.
//  Copyright (c) 2013 LTU. All rights reserved.
//

#import "AldPlayerSelectionViewController.h"
#import "AldPortraitSelectionViewController.h"

@interface AldPlayerSelectionViewController ()

@property(nonatomic) NSUInteger numberOfPlayers;

@end

@implementation AldPlayerSelectionViewController

#pragma mark - Table view data source
-(NSIndexPath *) tableView: (UITableView *)tableView willSelectRowAtIndexPath: (NSIndexPath *)indexPath
{
    _numberOfPlayers = indexPath.row + 1;
    return indexPath;
}

#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
-(void)prepareForSegue: (UIStoryboardSegue *)segue sender: (id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    AldPortraitSelectionViewController *nextController = (AldPortraitSelectionViewController *)segue.destinationViewController;
    nextController.numberOfPlayers = _numberOfPlayers;
}

@end
