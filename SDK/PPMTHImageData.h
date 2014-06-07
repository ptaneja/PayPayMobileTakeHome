//
//  PPMTHImageData.h
//  PayPayMobileTakeHome
//
//  Created by Tringapps Inc on 6/6/14.
//  Copyright (c) 2014 TringApps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface PPMTHImageData : NSObject

@property (nonatomic, strong) ALAsset *fullData;
@property (nonatomic, strong) NSURL *url;

@end
