//
//  NewFractionViewController.h
//  Machac
//
//  Created by Jan Schwarz on 22/07/14.
//  Copyright (c) 2014 Jan Schwarz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewFractionViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate, NSFetchedResultsControllerDelegate>
@property (strong, nonatomic) id detailItem;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) IBOutlet UIPickerView *pickerView;

@property (strong, nonatomic) IBOutlet UITextField *txtFraction;
@end
