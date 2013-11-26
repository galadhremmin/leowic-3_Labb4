//
//  AldPortraitSelectionViewController.m
//  leowic-3_Labb4
//
//  Created by Leonard Wickmark on 26/11/13.
//  Copyright (c) 2013 LTU. All rights reserved.
//

#import "AldPortraitSelectionViewController.h"

@interface AldPortraitSelectionViewController ()

@property(nonatomic, strong) NSMutableArray *portraitCells;

@end

@implementation AldPortraitSelectionViewController

-(void) viewDidAppear: (BOOL)animated
{
    _portraitCells = [[NSMutableArray alloc] initWithCapacity:_numberOfPlayers];
}

#pragma mark - Table view data source

-(BOOL) tableView: (UITableView *)tableView shouldHighlightRowAtIndexPath: (NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell != nil) {
        
        if ([_portraitCells containsObject:cell]) {
            [_portraitCells removeObject:cell];
            cell.accessoryType = UITableViewCellAccessoryNone;
            
        } else {
            if (_numberOfPlayers == _portraitCells.count) {
                UITableViewCell *cell = [_portraitCells objectAtIndex:_portraitCells.count - 1];
                cell.accessoryType = UITableViewCellAccessoryNone;
                [_portraitCells removeObject:cell];
            }
            
            [_portraitCells addObject:cell];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
   
    return NO;
}

#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
-(void) prepareForSegue: (UIStoryboardSegue *)segue sender: (id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
}

@end
