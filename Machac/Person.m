//
//  Person.m
//  Machac
//
//  Created by Jan Schwarz on 22/07/14.
//  Copyright (c) 2014 Jan Schwarz. All rights reserved.
//

#import "Person.h"
#import "Fraction.h"
#import "Item.h"
#import "AppDelegate.h"

@implementation Person

@dynamic name;
@dynamic debts;
@dynamic acquisitions;

+(NSArray*)getAllPeople {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSManagedObjectContext* context = ((AppDelegate*)[UIApplication sharedApplication].delegate).managedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Person" inManagedObjectContext:context];
    NSSortDescriptor *sort = [[NSSortDescriptor alloc]
                              initWithKey:@"name" ascending:YES];
    [fetchRequest setEntity:entity];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sort, nil]];
    [fetchRequest setFetchBatchSize:20];

    NSError* error;
    NSArray* people = [context executeFetchRequest:fetchRequest error:&error];
    
    return people;
}

@end
