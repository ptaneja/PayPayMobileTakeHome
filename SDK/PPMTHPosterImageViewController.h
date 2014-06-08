//
//  PPMTHPosterImageViewController.h
//  PayPayMobileTakeHome
//
//  Created by Tringapps Inc on 6/6/14.
//  Copyright (c) 2014 TringApps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PPMTHPosterImageViewController : UIViewController

@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) UIImage *posterImage;
@property (nonatomic, strong) IBOutlet UIButton *backButton;
@property (nonatomic, strong) IBOutlet UILabel *pictureTitle;
@property (nonatomic, strong) IBOutlet UILabel *date;
@property (nonatomic, strong) IBOutlet UILabel *location;
@property (nonatomic, strong) NSDate *pictureDate;
@property (nonatomic, strong) NSString *pictureLocation;
@property (nonatomic, strong) NSString *URL;

- (IBAction)backButton:(id)sender;

@end
