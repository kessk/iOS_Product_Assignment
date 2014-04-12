//
//  MCDetailViewController.h
//  Assignment
//
//  Created by Kessler Koh on 4/11/14.
//  Copyright (c) 2014 Macys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCImageViewController.h"

@interface MCDetailViewController : UIViewController <NSURLConnectionDataDelegate>

@property (strong, nonatomic) NSDictionary *productDictionary;

@property (strong, nonatomic) IBOutlet UILabel *productNameTextLabel;
@property (strong, nonatomic) IBOutlet UILabel *productDescriptionTextLabel;

@property (strong, nonatomic) IBOutlet UILabel *regularPriceTextLabel;
@property (strong, nonatomic) IBOutlet UILabel *salePriceTextLabel;

@property (strong, nonatomic) IBOutlet UIImageView *productImage;
@property (strong, nonatomic) NSMutableData *imageData;
@property (strong, nonatomic) UIImage *image;
@end
