//
//  FractionViewController.h
//  Machac
//
//  Created by Jan Schwarz on 22/07/14.
//  Copyright (c) 2014 Jan Schwarz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Item.h"

@interface FractionViewController : UITableViewController <NSFetchedResultsControllerDelegate, UIAlertViewDelegate>
@property (strong, nonatomic) Item* detailItem;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
