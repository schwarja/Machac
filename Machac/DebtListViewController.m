//
//  DebtListViewController.m
//  Machac
//
//  Created by Jan Schwarz on 22/07/14.
//  Copyright (c) 2014 Jan Schwarz. All rights reserved.
//

#import "DebtListViewController.h"
#import "ListCell.h"
#import "Fraction.h"
#import "Item.h"
#import "Person.h"
#import "AppDelegate.h"

@interface DebtListViewController ()

@end

@implementation DebtListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    switch (self.type) {
        case ListTypeAcq:
            self.navigationItem.title = [NSString stringWithFormat:@"Je mu/jí dluženo - %@",[[self.detailItem valueForKey:@"name"] description]];
            break;
            
        case ListTypeDebt:
            self.navigationItem.title = [NSString stringWithFormat:@"Dluží - %@",[[self.detailItem valueForKey:@"name"] description]];
            break;
            
        default:
            break;
    }
    
    self.managedObjectContext = ((AppDelegate*)[UIApplication sharedApplication].delegate).managedObjectContext;

    NSError *error;
	if (![[self fetchedResultsController] performFetch:&error]) {
		// Update to handle the error appropriately.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();  // Fail
	}
    
}

- (void)setDetailItem:(id)newDetailItem withType:(ListType)type
{
    self.type = type;
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Fetcher

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Person" inManagedObjectContext:self.managedObjectContext];
    NSSortDescriptor *sort = [[NSSortDescriptor alloc]
                              initWithKey:@"name" ascending:YES];
    [fetchRequest setEntity:entity];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sort, nil]];
    [fetchRequest setFetchBatchSize:20];
    [fetchRequest setPredicate:[self getPredicate]];
    NSFetchedResultsController *theFetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:self.managedObjectContext
                                          sectionNameKeyPath:nil
                                                   cacheName:nil];
    
    
    _fetchedResultsController = theFetchedResultsController;
    _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
    
}

-(NSPredicate*)getPredicate {
    NSString* predicate = [NSString stringWithFormat:@"name != \"%@\"",[[self.detailItem valueForKey:@"name"] description] ];
    return [NSPredicate predicateWithFormat:predicate];
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller is about to start sending change notifications, so prepare the table view for updates.
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.tableView;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray
                                               arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray
                                               arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller has sent all current change notifications, so tell the table view to process all updates.
    [self.tableView endUpdates];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The table view should not be re-orderable.
    return NO;
}

- (void)configureCell:(ListCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.lblName.text = [[object valueForKey:@"name"] description];
    float value = [self getAcquisitionForPerson:object] - [self getDebtToPerson:object];
    switch (self.type) {
        case ListTypeAcq:
            if (value < 0) value = 0;
            break;
            
        case ListTypeDebt:
            if (value >= 0) value = 0;
            else value = -value;
            break;
            
        default:
            break;
    }
    cell.lblValue.text = [NSString stringWithFormat:@"%.02f",value ];
}

-(float)getDebtToPerson:(NSManagedObject*)person {
    NSManagedObjectContext *context = self.managedObjectContext;
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Fraction" inManagedObjectContext:context]];
    [request setPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"debtor.name = \"%@\" && item.owner.name = \"%@\"",[[self.detailItem valueForKey:@"name"] description], [[person valueForKey:@"name"] description] ] ] ];
    NSError* error;
    NSArray* data = [context executeFetchRequest:request error:&error];
    
    float value = 0;
    
    for (Fraction* fraction in data) {
        value += fraction.fraction * fraction.item.value;
    }
    
    return value;
}

-(float)getAcquisitionForPerson:(NSManagedObject*)person {
    NSManagedObjectContext *context = self.managedObjectContext;
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Fraction" inManagedObjectContext:context]];
    [request setPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"debtor.name = \"%@\" && item.owner.name = \"%@\"", [[person valueForKey:@"name"] description], [[self.detailItem valueForKey:@"name"] description] ] ] ];
    NSError* error;
    NSArray* data = [context executeFetchRequest:request error:&error];
    
    float value = 0;
    
    for (Fraction* fraction in data) {
        value += fraction.fraction * fraction.item.value;
    }
    
    return value;
}

@end
