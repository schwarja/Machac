//
//  Item.h
//  Machac
//
//  Created by Jan Schwarz on 22/07/14.
//  Copyright (c) 2014 Jan Schwarz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Fraction, Person;

@interface Item : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic) float value;
@property (nonatomic, retain) NSSet *debtor;
@property (nonatomic, retain) Person *owner;

@end
