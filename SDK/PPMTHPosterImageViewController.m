//
//  PPMTHPosterImageViewController.m
//  PayPayMobileTakeHome
//
//  Created by Tringapps Inc on 6/6/14.
//  Copyright (c) 2014 TringApps. All rights reserved.
//

#import "PPMTHPosterImageViewController.h"

@interface PPMTHPosterImageViewController ()

@end

@implementation PPMTHPosterImageViewController

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
    self.imageView.image = self.posterImage;
    self.date.text = [NSString stringWithFormat:@"Date: %@", [self.pictureDate description]];
    self.location.text = [NSString stringWithFormat:@"Location: %@", self.pictureLocation];
}

- (IBAction)backButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
