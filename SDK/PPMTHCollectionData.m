//
//  PPMTHCollectionData.m
//  PayPayMobileTakeHome
//
//  Created by Tringapps Inc on 6/6/14.
//  Copyright (c) 2014 TringApps. All rights reserved.
//

#import "PPMTHCollectionData.h"
#import "PPMTHImageData.h"
#import <AssetsLibrary/AssetsLibrary.h>

@implementation PPMTHCollectionData
@synthesize dataPath;

- (void)prepareItems:(NSArray *)iItems {

    if (self.items == nil) {
        self.items = [[NSMutableArray alloc] init];
    }
    
    for (ALAsset *anImageData in iItems) {
        PPMTHImageData *iImageData = [[PPMTHImageData alloc] init];
        iImageData.url = [[anImageData valueForProperty:ALAssetPropertyURLs] objectForKey:[[anImageData valueForProperty:ALAssetPropertyRepresentations] objectAtIndex:0]];        
        iImageData.date = [anImageData valueForProperty:ALAssetPropertyDate];
        iImageData.location = [anImageData valueForProperty:ALAssetPropertyLocation];
        iImageData.fullData = anImageData;
        [self.items addObject:iImageData];

    }
}

@end
