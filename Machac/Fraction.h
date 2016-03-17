//
//  Fraction.h
//  Machac
//
//  Created by Jan Schwarz on 22/07/14.
//  Copyright (c) 2014 Jan Schwarz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Item, Person;

@interface Fraction : NSManagedObject

@property (nonatomic) float fraction;
@property (nonatomic, retain) Item *item;
@property (nonatomic, retain) Person *debtor;

@end
