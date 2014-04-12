//
//  MCDetailViewController.m
//  Assignment
//
//  Created by Kessler Koh on 4/11/14.
//  Copyright (c) 2014 Macys. All rights reserved.
//

#import "MCDetailViewController.h"

@interface MCDetailViewController ()

@end

@implementation MCDetailViewController

- (NSDictionary *)productDictionary
{
    if (!_productDictionary) {
        _productDictionary = [[NSDictionary alloc] init];
    }
    return _productDictionary;
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
    self.productNameTextLabel.text = self.productDictionary[@"name"];
    self.productDescriptionTextLabel.text = self.productDictionary[@"description"];
    self.regularPriceTextLabel.text = [NSString stringWithFormat:@"%@", self.productDictionary[@"regularPrice"]];
    self.salePriceTextLabel.text = [NSString stringWithFormat:@"%@", self.productDictionary[@"salePrice"]];
    
    self.productImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.productDictionary[@"productPhoto"]]]];
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint location = [touch locationInView:self.view];
    
    if (location.x >= self.productImage.frame.origin.x && location.x <= self.productImage.frame.origin.x + self.productImage.frame.size.width && location.y >= self.productImage.frame.origin.y && location.y <= self.productImage.frame.origin.y + self.productImage.frame.size.height) {
        NSLog(@"Clicked here");
        
        [self performSegueWithIdentifier:@"imageVCSegue" sender:self];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[MCImageViewController class]]) {
        MCImageViewController *destinationVC = segue.destinationViewController;
        destinationVC.photoURLString = self.productDictionary[@"productPhoto"];
    }
}

@end
