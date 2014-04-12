//
//  MCViewController.h
//  Assignment
//
//  Created by Kessler Koh on 4/9/14.
//  Copyright (c) 2014 Macys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "MCProductsTableViewController.h"

@interface MCViewController : UIViewController <NSURLConnectionDataDelegate>

@property (strong, nonatomic) NSString *databasePath;
@property (nonatomic) sqlite3 *productDB;

- (IBAction)createProductButtonPressed:(UIButton *)sender;
- (IBAction)showProductButtonPressed:(UIButton *)sender;

@end
