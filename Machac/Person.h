//
//  Person.h
//  Machac
//
//  Created by Jan Schwarz on 22/07/14.
//  Copyright (c) 2014 Jan Schwarz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Fraction, Item;

@interface Person : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *debts;
@property (nonatomic, retain) NSSet *acquisitions;
@end

@interface Person (CoreDataGeneratedAccessors)

- (void)addDebtsObject:(Fraction *)value;
- (void)removeDebtsObject:(Fraction *)value;
- (void)addDebts:(NSSet *)values;
- (void)removeDebts:(NSSet *)values;

- (void)addAcquisitionsObject:(Item *)value;
- (void)removeAcquisitionsObject:(Item *)value;
- (void)addAcquisitions:(NSSet *)values;
- (void)removeAcquisitions:(NSSet *)values;

@end
