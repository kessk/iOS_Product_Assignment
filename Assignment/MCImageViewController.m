//
//  MCImageViewController.m
//  Assignment
//
//  Created by Kessler Koh on 4/11/14.
//  Copyright (c) 2014 Macys. All rights reserved.
//

#import "MCImageViewController.h"

@interface MCImageViewController ()

@end

@implementation MCImageViewController

- (NSString *)photoURLString
{
    if (!_photoURLString) {
        _photoURLString = [[NSString alloc] init];
    }
    return _photoURLString;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.photoView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.photoURLString]]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
