//
//  DetailViewController.m
//  Machac
//
//  Created by Jan Schwarz on 22/07/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import "DetailViewController.h"
#import "DebtListViewController.h"
#import "Item.h"
#import "Fraction.h"

@interface CSVString : NSObject

@property (strong, nonatomic) NSString* csvString;
@property (strong, nonatomic) NSString* currentLine;

-(instancetype)init;

-(NSString*)csvString;

-(void)newLine;
-(void)addColumn:(NSString*)column;
-(void)addFloatColumn:(float)column;

@end

@implementation CSVString

@synthesize csvString;

-(instancetype)init {
    self = [super init];
    self.csvString = @"";
    self.currentLine = @"";
    return self;
}

-(NSString*)csvString {
    if ([csvString isEqualToString:@""]) {
        return self.currentLine;
    }
    else {
        return [NSString stringWithFormat:@"%@\n%@", csvString, self.currentLine];
    }
}

-(void)newLine {
    if ([csvString isEqualToString:@""]) {
        csvString = self.currentLine;
    }
    else {
        csvString = [NSString stringWithFormat:@"%@\n%@", csvString, self.currentLine];
    }
    self.currentLine = @"";
}

-(void)addFloatColumn:(float)column {
    [self addColumn:[NSString stringWithFormat:@"%g", column]];
}

-(void)addColumn:(NSString *)column {
    NSString* normalizedColumn = [NSString stringWithFormat:@"\"%@\"", column];
    if ([self.currentLine isEqualToString:@""]) {
        self.currentLine = normalizedColumn;
    }
    else {
        self.currentLine = [NSString stringWithFormat:@"%@,%@", self.currentLine, normalizedColumn];
    }
}

@end


@interface DetailViewController ()
- (void)configureView;
@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setPerson:(Person *)newPerson {
    if (_person != newPerson) {
        _person = newPerson;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView {
    // Update the user interface for the detail item.

    if (self.person) {
        self.navigationItem.title = self.person.name;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Export" style:UIBarButtonItemStylePlain target:self action:@selector(onBtnExportClick:)];
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

-(void)onBtnExportClick:(id)sender {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *fileName = [NSString stringWithFormat:@"%@/Export-%@.csv", documentsDirectory, self.person.name];

    [self createFileToExport: fileName];
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[[NSURL fileURLWithPath:fileName]] applicationActivities:nil];
    
    [self presentViewController:activityViewController animated:YES completion:nil];
}

-(void)createFileToExport:(NSString*)exportPath {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSError *error;
    [fileManager removeItemAtPath:exportPath error:&error];
    
    NSString *content = [self exportContentForPerson:self.person];
    
    [content writeToFile:exportPath
              atomically:NO
                encoding:NSUTF8StringEncoding
                   error:&error];
}

-(NSString*)exportContentForPerson:(Person*)person {
    NSArray* people = [Person getAllPeople];
    
    CSVString* content = [[CSVString alloc] init];
    
    //PAID FOR ITEMS
    [content addColumn:@"Paid for items"];
    [content newLine];

    [content addColumn:@"Item"];
    [content addColumn:@"Price"];
    for (Person* per in people) {
        if (per != person) {
            [content addColumn:per.name];
        }
    }
    [content newLine];
    
    NSMutableDictionary* isOwed = [NSMutableDictionary dictionary];
    float totalPaid = 0;
    
    for (Item* item in person.acquisitions) {
        totalPaid += item.value;
        
        [content addColumn:item.name];
        [content addFloatColumn:item.value];
        
        NSMutableDictionary* fractions = [NSMutableDictionary dictionary];
        
        for (Fraction* fraction in item.debtor) {
            [fractions setValue:[NSNumber numberWithFloat:fraction.fraction] forKey:fraction.debtor.name];
            float debt = [[isOwed valueForKey:fraction.debtor.name] floatValue] + (fraction.fraction*item.value);
            [isOwed setValue:[NSNumber numberWithFloat:debt] forKey:fraction.debtor.name];
        }
        
        for (Person* per in people) {
            if (per != person) {
                [content addFloatColumn:[[fractions valueForKey:per.name] floatValue]];
            }
        }
        
        [content newLine];
    }

    [content addColumn:@""];
    [content addFloatColumn:totalPaid];
    for (Person* per in people) {
        if (per != person) {
            [content addFloatColumn:[[isOwed valueForKey:per.name] floatValue]];
        }
    }
    [content newLine];
    
    [content newLine];

    //OWES FOR ITEMS
    [content addColumn:@"Owes for items"];
    [content newLine];
    
    [content addColumn:@"Item"];
    [content addColumn:@"Price"];
    for (Person* per in people) {
        if (per != person) {
            [content addColumn:per.name];
        }
    }
    [content addColumn:@"Debt"];
    [content newLine];
    
    NSMutableDictionary* owes = [NSMutableDictionary dictionary];
    float totalDebt = 0;
    
    for (Fraction* fraction in person.debts) {
        [content addColumn:fraction.item.name];
        [content addFloatColumn:fraction.item.value];
        
        for (Person* per in people) {
            if (per != person) {
                if (per == fraction.item.owner) {
                    [content addFloatColumn:fraction.fraction];
                }
                else {
                    [content addFloatColumn:0];
                }
            }
        }
        
        float debt = [[owes valueForKey:fraction.item.owner.name] floatValue] + (fraction.fraction*fraction.item.value);
        [owes setValue:[NSNumber numberWithFloat:debt] forKey:fraction.item.owner.name];
        [content addFloatColumn:fraction.fraction*fraction.item.value];
        totalDebt += fraction.fraction*fraction.item.value;
        [content newLine];
    }

    [content addColumn:@""];
    [content addColumn:@""];
    for (Person* per in people) {
        if (per != person) {
            [content addFloatColumn:[[owes valueForKey:per.name] floatValue]];
        }
    }
    [content addFloatColumn:totalDebt];
    [content newLine];
    [content newLine];
    
    [content addColumn:@"Total is owned"];
    [content newLine];
    for (Person* per in people) {
        if (per != person) {
            [content addColumn:per.name];
        }
    }
    [content newLine];
    for (Person* per in people) {
        if (per != person) {
            float income = [[isOwed valueForKey:per.name] floatValue] - [[owes valueForKey:per.name] floatValue];
            [content addFloatColumn:MAX(income, 0)];
        }
    }
    [content newLine];
    [content newLine];
    
    [content addColumn:@"Total owes"];
    [content newLine];
    for (Person* per in people) {
        if (per != person) {
            [content addColumn:per.name];
        }
    }
    [content newLine];
    for (Person* per in people) {
        if (per != person) {
            float debt = [[owes valueForKey:per.name] floatValue] - [[isOwed valueForKey:per.name] floatValue];
            [content addFloatColumn:MAX(debt, 0)];
        }
    }
    [content newLine];
    
    
    return [content csvString];
}

#pragma mark Segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"DebtSegue"]) {
        [((DebtListViewController*)[segue destinationViewController]) setDetailItem:self.person withType:ListTypeDebt];
    }
    else if ([segue.identifier isEqualToString:@"AcqSegue"]) {
        [((DebtListViewController*)[segue destinationViewController]) setDetailItem:self.person withType:ListTypeAcq];
    }
    else if ([segue.identifier isEqualToString:@"ItemSegue"]) {
        [[segue destinationViewController] setDetailItem:self.person];
    }

}
@end
