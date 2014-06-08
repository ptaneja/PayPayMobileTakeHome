//
//  PPMTHCollectionView.h
//  PayPayMobileTakeHome
//
//  Created by Tringapps Inc on 6/6/14.
//  Copyright (c) 2014 TringApps. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>

@protocol PPMTHCollectionViewDataSource <NSObject>
@optional
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView;
@end

@protocol PPMTHCollectionViewDelegate <NSObject>
@optional
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)collectionView:(UICollectionView *)collectionView didSelectItemWithImage:(UIImage *)iImage  date:(NSDate *)iDate location:(NSString *)iLocation;
- (void)collectionView:(UICollectionView *)collectionView didSelectItemWithImageURL:(NSString *)iURL;
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath;
@end

#import <UIKit/UIKit.h>

@interface PPMTHCollectionView : NSObject <UICollectionViewDelegate, UICollectionViewDataSource>

/**
    Method to get collection view: Grid view: Show pictures from the photo album in the grid
    Arg 1. iFrame: Frame of the content view
    Arg 2. iContentView: Frame of the content view
 **/
- (id)initWithFrame:(CGRect)iFrame andContentView:(UIView *)iContentView;

/**
 Method to get collection view: Grid view: This method needs all inputs from the user
 Arg 1. iDelegate: Delegate
 Arg 2. iDataSource: Data source
 Arg 3. iContentView: Frame of the content view
 Arg 4. iContentView: Frame of the content view
 **/
- (id)initWithDelegate:(id)iDelegate andDataSource:(id)iDataSource andFrame:(CGRect)iFrame andContentView:(UIView *)iContentView;

/**
 Method to get collection view: Grid view: Show pictures from the remote server
 Arg 1. iURLs: Frame of the content view
 Arg 2. iContentView: Frame of the content view
 Arg 3. iContentView: Frame of the content view
 **/
- (id)initWithImagesFromURLs:(NSMutableArray *)iURLs andContentView:(UIView *)iContentView andFrame:(CGRect)iFrame;

- (void)refreshView;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) id <PPMTHCollectionViewDataSource> dataSource;
@property (nonatomic, assign) id <PPMTHCollectionViewDelegate> delegate;


@end
