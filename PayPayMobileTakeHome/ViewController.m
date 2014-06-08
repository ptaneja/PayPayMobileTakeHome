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
    aRect.origin.y = aRect.origin.y + 80;
    aRect.size.height = aRect.size.height - 80;
    
    self.photosView = [[PPMTHCollectionView alloc] initWithFrame:aRect andContentView:self.view];
    self.photosView.delegate = self;
    self.photosView.dataSource = self;
    [self.label setText:@"Your Photos"];
}

- (UILabel *)titleLabel {
    UILabel *aLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, 320, 50)];
    aLabel.textAlignment = NSTextAlignmentCenter;
    [aLabel setText:@"Your Photos"];
    return aLabel;
}

-(IBAction)segmentAction:(id)sender {
    CGRect aRect = [[UIScreen mainScreen] bounds];
    aRect.origin.y = aRect.origin.y + 80;
    aRect.size.height = aRect.size.height - 80;
    
    if ([sender selectedSegmentIndex] == 0) {
        if (self.cloudview) {
            [self.cloudview.collectionView setHidden:YES];
        }
        
        if (self.photosView) {
            [self.photosView.collectionView setHidden:NO];
            [self.photosView refreshView];
        } else {
            self.photosView = [[PPMTHCollectionView alloc] initWithFrame:aRect andContentView:self.view];
            self.photosView.delegate = self;
            self.photosView.dataSource = self;
        }
        [self.label setText:@"Your Photos"];
    } else {
        if (self.photosView) {
            [self.photosView.collectionView setHidden:YES];
        }
        
        if (self.cloudview) {
            [self.cloudview.collectionView setHidden:NO];
            [self.cloudview refreshView];
        } else {
            self.cloudview = [[PPMTHCollectionView alloc] initWithImagesFromURLs:[self prepareURL] andContentView:self.view andFrame:aRect];
            self.cloudview.delegate = self;
            self.cloudview.dataSource = self;
        }
        [self.label setText:@"Cloud"];
    }
}

- (NSMutableArray *)prepareURL {
    NSMutableArray *URLs = [NSMutableArray array];
    
    for (int i = 11; i <= 99; i++) {
        [URLs addObject:[NSString stringWithFormat:@"https://s3.amazonaws.com/fast-image-cache/demo-images/FICDDemoImage0%d.jpg",i]];
    }
    return URLs;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemWithImageURL:(NSString *)iURL {
    PPMTHPosterImageViewController *posterImageViewController = [[PPMTHPosterImageViewController alloc] initWithNibName:@"PPMTHPosterImageViewController" bundle:nil];
    posterImageViewController.URL = iURL;
    [self presentViewController:posterImageViewController animated:YES completion:nil];

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
