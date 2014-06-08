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
    
    if (self.URL) {
        [self downloadImageWithURL:self.URL completionBlock:^(BOOL succeeded, UIImage *image) {
            __weak PPMTHPosterImageViewController *aBlock = self;
            
            if (image) {
                aBlock.imageView.image = image;
            }
        }];
    } else {
    self.imageView.image = self.posterImage;
    self.date.text = [NSString stringWithFormat:@"Date: %@", [self.pictureDate description]];
    self.location.text = [NSString stringWithFormat:@"Location: %@", self.pictureLocation];
    }
}

- (void)downloadImageWithURL:(NSString *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if ( !error )
                               {
                                   UIImage *image = [[UIImage alloc] initWithData:data];
                                   completionBlock(YES,image);
                               } else{
                                   completionBlock(NO,nil);
                               }
                           }];
}

- (IBAction)backButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
