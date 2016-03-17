//
//  DetailViewController.m
//  Machac
//
//  Created by Jan Schwarz on 22/07/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import "DetailViewController.h"
#import "DebtListViewController.h"

@interface DetailViewController ()
- (void)configureView;
@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.detailItem) {
        self.navigationItem.title = [[self.detailItem valueForKey:@"name"] description];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onBtnDebtsClick:(id)sender {
}

- (IBAction)onBtnAcquisitionClick:(id)sender {
}

#pragma mark Segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"DebtSegue"]) {
        [((DebtListViewController*)[segue destinationViewController]) setDetailItem:self.detailItem withType:ListTypeDebt];
    }
    else if ([segue.identifier isEqualToString:@"AcqSegue"]) {
        [((DebtListViewController*)[segue destinationViewController]) setDetailItem:self.detailItem withType:ListTypeAcq];
    }
    else if ([segue.identifier isEqualToString:@"ItemSegue"]) {
        [[segue destinationViewController] setDetailItem:self.detailItem];
    }

}
@end
