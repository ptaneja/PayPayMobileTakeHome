//
//  PPMTHCollectionData.h
//  PayPayMobileTakeHome
//
//  Created by Tringapps Inc on 6/6/14.
//  Copyright (c) 2014 TringApps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PPMTHCollectionData : NSObject

@property (nonatomic, strong) NSString *dataPath;
@property (nonatomic, strong) NSMutableArray *items;
- (void)prepareItems:(NSArray *)iItems;

@end
