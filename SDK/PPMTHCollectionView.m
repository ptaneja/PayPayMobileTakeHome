
//
//  PPMTHCollectionView.m
//  PayPayMobileTakeHome
//
//  Created by Tringapps Inc on 6/6/14.
//  Copyright (c) 2014 TringApps. All rights reserved.
//

#import "PPMTHCollectionView.h"
#import "PPMTHCollectionData.h"
#import "PPMTHImageData.h"

@interface PPMTHCollectionView ()

@property (nonatomic, strong) PPMTHCollectionData *data;
@property (nonatomic, strong) NSMutableArray *tempAssets;
@property (nonatomic, strong) ALAssetsLibrary *assetLibrary;

@end

@implementation PPMTHCollectionView 

static NSString *cellIdentifier = @"Cell";

- (id)initWithFrame:(CGRect)iFrame andContentView:(UIView *)iContentView
{
    if (self = [super init]) {
        self.data = [[PPMTHCollectionData alloc] init];
        
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [activityIndicator setFrame:iFrame];
        [iContentView addSubview:activityIndicator];
        [activityIndicator startAnimating];
        
        self.assetLibrary = [[ALAssetsLibrary alloc] init];
        
        __block NSMutableArray *tmpAssets = [@[] mutableCopy];
        [self.assetLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            __weak PPMTHCollectionView *aBlock = self;
            
            [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                if(result) {
                    [tmpAssets addObject:result];
                }
            }];
            aBlock.tempAssets = tmpAssets;
            [activityIndicator stopAnimating];
            [activityIndicator removeFromSuperview];
            
            [aBlock.data prepareItems:aBlock.tempAssets];
            
            UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
            aBlock.collectionView = [[UICollectionView alloc] initWithFrame:iFrame collectionViewLayout:layout];
            [aBlock.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellIdentifier];
            aBlock.collectionView.delegate = aBlock;
            aBlock.collectionView.dataSource = aBlock;
            [iContentView addSubview:aBlock.collectionView];
            
            [aBlock.collectionView reloadData];
        } failureBlock:^(NSError *error) {
            NSLog(@"Error loading images %@", error);
        }];
    }
    return self;
}

- (id)initWithDelegate:(id)iDelegate andDataSource:(id)iDataSource andFrame:(CGRect)iFrame andContentView:(UIView *)iContentView
{
    if (self = [super init]) {
        self.data = [[PPMTHCollectionData alloc] init];
        self.collectionView = [[UICollectionView alloc] initWithFrame:iFrame];
        [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellIdentifier];
        self.dataSource = iDataSource;
        self.delegate = iDelegate;
    }
    return self;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger numberOfItemsInSection = 0;
    
    if ([self.dataSource respondsToSelector:@selector(collectionView:numberOfItemsInSection:)]) {
        numberOfItemsInSection = [self.dataSource collectionView:collectionView numberOfItemsInSection:section];
    } else {
        numberOfItemsInSection = [self.data.items count];
    }
    return numberOfItemsInSection;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *collectionViewCell = nil;
    
    if ([self.dataSource respondsToSelector:@selector(collectionView:numberOfItemsInSection:)]) {
        collectionViewCell = [self.dataSource collectionView:collectionView cellForItemAtIndexPath:indexPath];
    } else {
        collectionViewCell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
        
        PPMTHImageData *imageData = [self.data.items objectAtIndex:indexPath.row];
        
        [self.assetLibrary assetForURL:imageData.url resultBlock:^(ALAsset *asset) {
            ALAssetRepresentation *assetRepresentation = asset.defaultRepresentation;
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImage *image = [UIImage imageWithCGImage:[asset thumbnail] scale:1 orientation:(UIImageOrientation)assetRepresentation.orientation];
                
                UIImageView *anImageView = [[UIImageView alloc] initWithImage:image];
                [anImageView setFrame:CGRectMake(0, 0, 100, 100)];
                anImageView.contentMode = UIViewContentModeScaleToFill;
                [collectionViewCell.contentView addSubview:anImageView];
            });
        } failureBlock:^(NSError *error) {
            NSLog(@"Failed to get Image");
        }];
    }
    return collectionViewCell;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    NSInteger numberOfSections = 0;

    if ([self.dataSource respondsToSelector:@selector(numberOfSectionsInCollectionView:)]) {
        numberOfSections = [self.dataSource numberOfSectionsInCollectionView:collectionView];
    } else {
        numberOfSections = 3;
    }
    return numberOfSections;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(collectionView:didSelectItemWithImage:date:location:)]) {
        
        PPMTHImageData *imageData = [self.data.items objectAtIndex:indexPath.row];
        
        
        [self.assetLibrary assetForURL:imageData.url resultBlock:^(ALAsset *asset) {
            ALAssetRepresentation *assetRepresentation = asset.defaultRepresentation;
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImage *image = [UIImage imageWithCGImage:assetRepresentation.fullResolutionImage scale:assetRepresentation.scale orientation:(UIImageOrientation)assetRepresentation.orientation];
                [self.delegate collectionView:collectionView didSelectItemWithImage:image date:imageData.date location:imageData.location];
            });
        } failureBlock:^(NSError *error) {
            NSLog(@"Failed to get Image");
        }];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(collectionView:didSelectItemAtIndexPath:)]) {
        [self.delegate collectionView:collectionView didDeselectItemAtIndexPath:indexPath];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(100, 100);
}

- (void) clearCells {
    
    NSArray *visibleCells = self.collectionView.visibleCells;
    
    CGRect visibleRect;
    visibleRect.origin = self.collectionView.contentOffset;
    visibleRect.size = self.collectionView.bounds.size;
    
    for (UIView *aView in [self.collectionView subviews]) {
        if ([aView isKindOfClass:UICollectionViewCell.class]) {
            CGPoint origin = aView.frame.origin;
            if(CGRectContainsPoint(visibleRect, origin)) {
                if (![visibleCells containsObject:aView]) {
                    [aView removeFromSuperview];
                }
            }
        }
    }
    [self.collectionView setNeedsDisplay];
}

- (void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self clearCells];
    }
}

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self clearCells];
}

@end
