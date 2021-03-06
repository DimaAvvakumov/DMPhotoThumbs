//
//  DMPhotoThumbs.h
//  DMPhotoThumbs
//
//  Created by Avvakumov Dmitry on 22.09.15.
//  Copyright (c) 2015 Dmitry Avvakumov. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DMPhotoThumbs, ALAssetsLibrary, ALAssetsFilter;

@protocol DMPhotoThumbsDataSource <NSObject>

@optional
- (ALAssetsLibrary *)assetLibraryForDMPhotoThumbs:(DMPhotoThumbs*)view;

@end

@protocol DMPhotoThumbsDelegate <NSObject>

@optional
- (void)dmPhotoThumbs:(DMPhotoThumbs*)view updateIemAtIndex:(NSInteger)index asCheck:(BOOL)check;
- (void)dmPhotoThumbs:(DMPhotoThumbs*)view tapItemAtIndex:(NSInteger)index;
- (void)dmPhotoThumbs:(DMPhotoThumbs*)view fetchError:(NSError *)error;
- (ALAssetsFilter *)dmPhotoThumbsAssetFilter:(DMPhotoThumbs*)view;

- (void)dmPhotoThumbsOpenCamera:(DMPhotoThumbs*)view;

@end

@interface DMPhotoThumbs : UIView

@property (weak, nonatomic) IBOutlet id<DMPhotoThumbsDataSource> dataSource;
@property (weak, nonatomic) IBOutlet id<DMPhotoThumbsDelegate> delegate;

@property (assign, nonatomic) UIEdgeInsets itemsInsets;
@property (assign, nonatomic) CGFloat itemInterspacing;

@property (assign, nonatomic) BOOL avaliablePreviewCell;

#pragma mark - Cell appereance
- (void) setCheckImage:(UIImage *)image forState:(UIControlState)controlState;
- (void) setPickPhotoIcon:(UIImage *)image;
- (void) setMultipleSelectEnabled:(BOOL) multipleSelectEnabled;

#pragma mark - Items data
- (NSUInteger) countOfItems;
- (NSArray *) items;

- (NSIndexSet *) checkedItems;
- (NSInteger)countCheckedItems;

- (void)setCheckedItems:(NSIndexSet *)indexSet;
- (void)clearCheckedItems;

#pragma mark - Prepare methods
- (void)prepareForShowing;
- (void)prepareForHidding;

@end
