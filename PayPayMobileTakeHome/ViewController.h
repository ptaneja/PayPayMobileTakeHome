//
//  ViewController.h
//  PayPayMobileTakeHome
//
//  Created by Tringapps Inc on 6/6/14.
//  Copyright (c) 2014 TringApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPMTHCollectionView.h"

@interface ViewController : UIViewController <PPMTHCollectionViewDelegate, PPMTHCollectionViewDataSource>

@property (nonatomic, strong) PPMTHCollectionView *mainView;

@end
