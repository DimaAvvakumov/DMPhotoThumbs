//
//  DMPhotoThumbs.h
//  DMPhotoThumbs
//
//  Created by Avvakumov Dmitry on 22.09.15.
//  Copyright (c) 2015 Dmitry Avvakumov. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DMPhotoThumbs;
@protocol DMPhotoThumbsDelegate <NSObject>

@optional
- (void)dmPhotoThumbs:(DMPhotoThumbs*)view updateIemAtIndex:(NSInteger)index asCheck:(BOOL)check;

@end

@interface DMPhotoThumbs : UIView

@property (weak, nonatomic) IBOutlet id<DMPhotoThumbsDelegate> delegate;

@property (assign, nonatomic) UIEdgeInsets itemsInsets;
@property (assign, nonatomic) CGFloat itemInterspacing;

@property (assign, nonatomic) BOOL avaliablePreviewCell;

#pragma mark - Cell appereance
- (void) setCheckImage:(UIImage *)image forState:(UIControlState)controlState;

#pragma mark - Items data
- (NSUInteger) countOfItems;
- (NSArray *) items;

- (NSIndexSet *) checkedItems;
- (NSInteger)countCheckedItems;

@end
