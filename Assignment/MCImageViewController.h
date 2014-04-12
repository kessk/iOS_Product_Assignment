//
//  MCImageViewController.h
//  Assignment
//
//  Created by Kessler Koh on 4/11/14.
//  Copyright (c) 2014 Macys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MCImageViewController : UIViewController

@property (strong, nonatomic) NSString *photoURLString;

@property (strong, nonatomic) IBOutlet UIImageView *photoView;
@end
