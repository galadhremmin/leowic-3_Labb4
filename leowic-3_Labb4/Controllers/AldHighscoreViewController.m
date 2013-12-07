//
//  AldHighscoreViewController.m
//  leowic-3_Labb4
//
//  Created by Leonard Wickmark on 05/12/13.
//  Copyright (c) 2013 LTU. All rights reserved.
//

#import "AldHighscoreViewController.h"
#import "AldHighscoreCell.h"


@interface AldHighscoreViewController ()

@property(nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end

@implementation AldHighscoreViewController

-(void) viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [NSFetchedResultsController deleteCacheWithName:@"HighscoreMaster"];
}

-(void) didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View

-(NSInteger) numberOfSectionsInTableView: (UITableView *)tableView
{
    NSInteger sectionCount = self.fetchedResultsController.sections.count;
    return sectionCount;
}

-(NSInteger) tableView: (UITableView *)tableView numberOfRowsInSection: (NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = self.fetchedResultsController.sections[section];
    NSInteger numberOfItems = [sectionInfo numberOfObjects];
    return numberOfItems;
}

-(UITableViewCell *) tableView: (UITableView *)tableView cellForRowAtIndexPath: (NSIndexPath *)indexPath
{
    AldHighscoreCell *cell = (AldHighscoreCell *)[tableView dequeueReusableCellWithIdentifier:@"HighscoreCell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    AldDataCore *core = [AldDataCore defaultCore];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:kAldDataCoreHighscoreEntityName inManagedObjectContext:core.managedObjectContext];
    
    fetchRequest.entity = entity;
    
    // Set the batch size to a suitable number.
    fetchRequest.fetchBatchSize = 20;
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"score" ascending:NO];
    fetchRequest.sortDescriptors = @[sortDescriptor];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *controller = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:core.managedObjectContext sectionNameKeyPath:nil cacheName:@"HighscoreMaster"];
    controller.delegate = self;

    _fetchedResultsController = controller;
    
	NSError *error = nil;
	if (![controller performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return controller;
}

-(void) controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [(UITableView *)self.view beginUpdates];
}

-(void) controller:(NSFetchedResultsController *)controller didChangeSection: (id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex: (NSUInteger)sectionIndex forChangeType: (NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [(UITableView *)self.view insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [(UITableView *)self.view deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

-(void) controller: (NSFetchedResultsController *)controller didChangeObject: (id)anObject
       atIndexPath: (NSIndexPath *)indexPath forChangeType: (NSFetchedResultsChangeType)type
      newIndexPath: (NSIndexPath *)newIndexPath
{
    UITableView *tableView = (UITableView *)self.view;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:(AldHighscoreCell *)[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

-(void) controllerDidChangeContent: (NSFetchedResultsController *)controller
{
    [(UITableView *)self.view endUpdates];
}

-(void) configureCell: (AldHighscoreCell *)cell atIndexPath: (NSIndexPath *)indexPath
{
    NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = [NSDateFormatter dateFormatFromTemplate:@"YYYYMMdd HH:mm" options:0 locale:[NSLocale currentLocale]];
    
    cell.highscoreRowLabel.text = [NSString stringWithFormat:@"%d.", indexPath.row + 1];
    cell.highscorePlayerNameLabel.text = [object valueForKey:@"playerName"];
    cell.highscoreDateLabel.text = [formatter stringFromDate:[object valueForKey:@"date"]];
    cell.highscoreScoreLabel.text = [NSString stringWithFormat:@"%d", [[object valueForKey:@"score"] unsignedIntegerValue]];
}

@end
