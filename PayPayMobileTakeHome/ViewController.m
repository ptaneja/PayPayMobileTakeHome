//
//  ViewController.m
//  PayPayMobileTakeHome
//
//  Created by Tringapps Inc on 6/6/14.
//  Copyright (c) 2014 TringApps. All rights reserved.
//

#import "ViewController.h"
#import "PPMTHPosterImageViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect aRect = [[UIScreen mainScreen] bounds];
    aRect.origin.y = aRect.origin.y + 50;
    
    self.mainView = [[PPMTHCollectionView alloc] initWithFrame:aRect andContentView:self.view];
    self.mainView.delegate = self;
    [self.view addSubview:[self titleLabel]];
}

- (UILabel *)titleLabel {
    UILabel *aLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    aLabel.textAlignment = NSTextAlignmentCenter;
    [aLabel setText:@"Your Photos"];
    return aLabel;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemWithImage:(UIImage *)iImage  date:(NSDate *)iDate location:(NSString *)iLocation {
    PPMTHPosterImageViewController *posterImageViewController = [[PPMTHPosterImageViewController alloc] initWithNibName:@"PPMTHPosterImageViewController" bundle:nil];
    posterImageViewController.posterImage = iImage;
    posterImageViewController.pictureDate = iDate;
    posterImageViewController.pictureLocation = iLocation;
    [self presentViewController:posterImageViewController animated:YES completion:nil];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
}

@end
