//
//  DebtListViewController.h
//  Machac
//
//  Created by Jan Schwarz on 22/07/14.
//  Copyright (c) 2014 Jan Schwarz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailViewController.h"

@interface DebtListViewController : UITableViewController <NSFetchedResultsControllerDelegate>
@property (nonatomic) ListType type;
@property (strong, nonatomic) id detailItem;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (void)setDetailItem:(id)newDetailItem withType:(ListType)type;

@end
