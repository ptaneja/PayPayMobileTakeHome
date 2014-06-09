//
//  ViewController.h
//  PayPayMobileTakeHome
//
//  Created by Tringapps Inc on 6/6/14.
//  Copyright (c) 2014 TringApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PPMTHLibrary/PPMTHCollectionView.h>

@interface ViewController : UIViewController <PPMTHCollectionViewDelegate, PPMTHCollectionViewDataSource>

@property (nonatomic, strong) PPMTHCollectionView *photosView;
@property (nonatomic, strong) PPMTHCollectionView *cloudview;

@property (nonatomic, strong) IBOutlet UILabel *label;
@property (nonatomic, strong) IBOutlet UISegmentedControl *segmentControl;
-(IBAction)segmentAction:(id)sender;

@end
