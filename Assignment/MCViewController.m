//
//  MCViewController.m
//  Assignment
//
//  Created by Kessler Koh on 4/9/14.
//  Copyright (c) 2014 Macys. All rights reserved.
//

#import "MCViewController.h"

@interface MCViewController ()

@property (strong,nonatomic) NSMutableArray *productsArray;

@end

@implementation MCViewController

- (NSMutableArray *)productsArray
{
    if (!_productsArray) {
        _productsArray = [[NSMutableArray alloc] init];
    }
    
    return _productsArray;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
    NSString *documentsDirectory;
    NSArray *directoryPath;
    
    directoryPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    documentsDirectory = directoryPath[0];
    
    _databasePath = [[NSString alloc] initWithString:[documentsDirectory stringByAppendingPathComponent:@"products.db"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)createProductButtonPressed:(UIButton *)sender
{
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *jsonPath = [mainBundle pathForResource:@"products" ofType:@"json"];
    
    //NSLog(@"Here is the path of the JSON file: %@", jsonPath);
    NSURL *jsonURL = [[NSURL alloc] initFileURLWithPath:jsonPath];
    NSData *data = [NSData dataWithContentsOfURL:jsonURL];
    NSError *error = nil;
    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    
    if ([self verifyDB]) {
        NSLog(@"DB has been verified.");
    } else {
        NSLog(@"Error connecting to the DB.");
    }
    [self insertInDB:jsonObject];
}

- (BOOL)verifyDB
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    const char *dbpath = [_databasePath UTF8String];
    
    if ([fileManager fileExistsAtPath:_databasePath] == NO) {
        NSLog(@"DB file does not exist.");
        
        if (sqlite3_open(dbpath, &_productDB) == SQLITE_OK) {
            const char *sqlStatement = "CREATE TABLE IF NOT EXISTS PRODUCTS (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT, DESCRIPTION TEXT, REGULARPRICE FLOAT, SALEPRICE FLOAT, PRODUCTPHOTO TEXT, COLORS BLOB, STORES BLOB)";
            
            char *errorMessage;
            
            if (sqlite3_exec(_productDB, sqlStatement, NULL, NULL, &errorMessage) != SQLITE_OK) {
                sqlite3_close(self.productDB);
                return NO;
            }
            
            sqlite3_close(self.productDB);
        } else {
            return NO;
        }
        return YES;
    } else {
        return YES;
    }
}

- (void)insertInDB:(NSDictionary *)data
{
    sqlite3_stmt *statement;
    const char *dbpath = [_databasePath UTF8String];
    
    for (NSDictionary *entry in data[@"Products"]) {
        if (sqlite3_open(dbpath, &_productDB) == SQLITE_OK) {
            NSLog(@"Opening of the database is successful.");
            
            NSArray *colorsArray = [NSArray arrayWithObject:entry[@"colors"]];
            NSLog(@"Here is the colorsArray: %@", colorsArray);
            NSData *dataFromArray = [NSKeyedArchiver archivedDataWithRootObject:colorsArray];
            const char *arrayInBytes = [dataFromArray bytes];
            //NSData *colorsData = [[NSData alloc] initWith]
            
           NSData *dataFromDictionary = [NSPropertyListSerialization dataFromPropertyList:entry[@"stores"] format:NSPropertyListBinaryFormat_v1_0 errorDescription:nil];
            
            NSString *insertStatement = [NSString stringWithFormat:@"INSERT INTO PRODUCTS (NAME, DESCRIPTION, REGULARPRICE, SALEPRICE, PRODUCTPHOTO, COLORS, STORES) VALUES (\"%@\", \"%@\", \"%f\", \"%f\", \"%@\", ?, ?)", entry[@"name"], entry[@"description"], [entry[@"regularPrice"] floatValue], [entry[@"salePrice"] floatValue], entry[@"productPhoto"]]; //], dataFromArray, dataFromDictionary];
            //NSString *insertStatement = [NSString stringWithFormat:@"INSERT INTO PRODUCTS (NAME) VALUES (\"Kess\")"];
            
            const char *insertThatStatement = [insertStatement UTF8String];
            if (sqlite3_prepare_v2(_productDB, insertThatStatement, -1, &statement, NULL) == SQLITE_OK) {
                sqlite3_bind_blob(statement, 1, arrayInBytes, [dataFromArray length], SQLITE_TRANSIENT);
                sqlite3_bind_blob(statement, 2, [dataFromDictionary bytes], [dataFromDictionary length], SQLITE_TRANSIENT);
            }
            if (sqlite3_step(statement) == SQLITE_DONE) {
                NSLog(@"Successfully stored the data.");
            } else {
                NSLog(@"Unsuccessful attempt to store data.");
            }
            sqlite3_finalize(statement);
            sqlite3_close(self.productDB);
        }
    }
    
}

- (IBAction)showProductButtonPressed:(UIButton *)sender
{
    const char *dbpath = [_databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &_productDB) == SQLITE_OK) {
        const char *querySQL = [[NSString stringWithFormat:@"SELECT ID, NAME, DESCRIPTION, REGULARPRICE, SALEPRICE, PRODUCTPHOTO FROM PRODUCTS"] UTF8String];
        
        if (sqlite3_prepare_v2(_productDB, querySQL, -1, &statement, NULL) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                NSString *name = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                NSString *description = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
                float regularPrice = (float) sqlite3_column_double(statement, 3);
                float salePrice = (float) sqlite3_column_double(statement, 4);
                NSString *productPhoto = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 5)];
                
                NSDictionary *dictionaryEntry = @{@"name":name, @"description":description, @"regularPrice":@(regularPrice), @"salePrice":@(salePrice), @"productPhoto":productPhoto};
                
                [self.productsArray addObject:dictionaryEntry];
                NSLog(@"Here is one dictionary entry as extracted from the DB: %@", dictionaryEntry);
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(_productDB);
        
        [self performSegueWithIdentifier:@"tableViewSegue" sender:self];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[MCProductsTableViewController class]]) {
        MCProductsTableViewController *productsTableVC = segue.destinationViewController;
        NSLog(@"Here are the arrays: %@", self.productsArray);
        productsTableVC.productsArray = self.productsArray;
    }
}

@end
