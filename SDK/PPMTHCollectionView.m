
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
@property (nonatomic, strong) UILabel *noDataLabel;

@end

@implementation PPMTHCollectionView 

static NSString *cellIdentifier = @"Cell";

- (id)initWithImagesFromURLs:(NSMutableArray *)iURLs andContentView:(UIView *)iContentView andFrame:(CGRect)iFrame {
    if (self = [super init]) {
        self.data = [[PPMTHCollectionData alloc] init];
        self.data.imageURLs = iURLs;
        
        UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
        self.collectionView = [[UICollectionView alloc] initWithFrame:iFrame collectionViewLayout:layout];
        [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellIdentifier];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        [iContentView addSubview:self.collectionView];
    }
    return self;
}

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
            [self refreshView];
            
            if (aBlock.data.items.count == 0) {
                self.noDataLabel = [[UILabel alloc] initWithFrame:iFrame];
                [self.noDataLabel setTextAlignment:NSTextAlignmentCenter];
                [self.noDataLabel setBackgroundColor:[UIColor grayColor]];
                [self.noDataLabel setText:@"No Photos"];
                [iContentView addSubview:self.noDataLabel];
            }
            
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

- (void)refreshView {
    if (self.data.imageURLs.count > 0 || self.data.items.count > 0) {
        [self.noDataLabel setHidden:NO];
    }
    [self.collectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger numberOfItemsInSection = 0;
    
    if ([self.dataSource respondsToSelector:@selector(collectionView:numberOfItemsInSection:)]) {
        numberOfItemsInSection = [self.dataSource collectionView:collectionView numberOfItemsInSection:section];
    } else {
        if (self.data.imageURLs) {
            numberOfItemsInSection = [self.data.imageURLs count];
        } else {
            numberOfItemsInSection = [self.data.items count];
        }
    }
    return numberOfItemsInSection;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    __block UICollectionViewCell *collectionViewCell = nil;
    
    if ([self.dataSource respondsToSelector:@selector(collectionView:numberOfItemsInSection:)]) {
        collectionViewCell = [self.dataSource collectionView:collectionView cellForItemAtIndexPath:indexPath];
    } else {
        if (self.data.imageURLs) {
            collectionViewCell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];

            [self downloadImageWithURL:[self.data.imageURLs objectAtIndex:indexPath.row] completionBlock:^(BOOL succeeded, UIImage *image) {
                if (succeeded) {
                    UIImageView *anImageView = [[UIImageView alloc] initWithImage:image];
                    [anImageView setFrame:CGRectMake(0, 0, 100, 100)];
                    anImageView.clipsToBounds = YES;
                    anImageView.layer.cornerRadius = 5.0;
                    anImageView.contentMode = UIViewContentModeScaleToFill;
                    [collectionViewCell.contentView addSubview:anImageView];
                }
            }];
        } else {
            collectionViewCell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
            
            PPMTHImageData *imageData = [self.data.items objectAtIndex:indexPath.row];
            
            [self.assetLibrary assetForURL:imageData.url resultBlock:^(ALAsset *asset) {
                ALAssetRepresentation *assetRepresentation = asset.defaultRepresentation;
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIImage *image = [UIImage imageWithCGImage:[asset thumbnail] scale:1 orientation:(UIImageOrientation)assetRepresentation.orientation];
                    
                    UIImageView *anImageView = [[UIImageView alloc] initWithImage:image];
                    [anImageView setFrame:CGRectMake(0, 0, 100, 100)];
                    anImageView.clipsToBounds = YES;
                    anImageView.layer.cornerRadius = 5.0;
                    anImageView.contentMode = UIViewContentModeScaleToFill;
                    [collectionViewCell.contentView addSubview:anImageView];
                });
            } failureBlock:^(NSError *error) {
                NSLog(@"Failed to get Image");
            }];
        }
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
    if (self.data.imageURLs && [self.delegate respondsToSelector:@selector(collectionView:didSelectItemWithImageURL:)]) {
        [self.delegate collectionView:collectionView didSelectItemWithImageURL:[self.data.imageURLs objectAtIndex:indexPath.row]];
    } else if ([self.delegate respondsToSelector:@selector(collectionView:didSelectItemWithImage:date:location:)]) {
        
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
