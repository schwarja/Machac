//
//  DetailViewController.h
//  Machac
//
//  Created by Jan Schwarz on 22/07/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    ListTypeDebt,
    ListTypeAcq
} ListType;

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@end
