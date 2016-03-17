//
//  ItemManagerViewController.h
//  Machac
//
//  Created by Jan Schwarz on 22/07/14.
//  Copyright (c) 2014 Jan Schwarz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemManagerViewController : UITableViewController <NSFetchedResultsControllerDelegate, UIAlertViewDelegate>
@property (strong, nonatomic) id detailItem;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
