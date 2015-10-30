//
//  DMPhotoThumbs.m
//  DMPhotoThumbs
//
//  Created by Avvakumov Dmitry on 22.09.15.
//  Copyright (c) 2015 Dmitry Avvakumov. All rights reserved.
//

#import "DMPhotoThumbs.h"

#import <AssetsLibrary/AssetsLibrary.h>

#import "DMPhotoThumbsPhotoCell.h"
#import "DMPhotoThumbsVizorCell.h"

@interface DMPhotoThumbs() <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) UICollectionView *collectionView;

@property (strong, nonatomic) NSArray *dataItems;

@property (assign, nonatomic) CGSize itemSize;

@property (strong, nonatomic) NSMutableDictionary *selectedItems;

@end

@implementation DMPhotoThumbs

- (id)init{
    self = [super init];
    if (self == nil) return self;
    
    [self initView];
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self == nil) return self;
    
    [self initView];
    
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self == nil) return self;
    
    [self initView];
    
    return self;
}

- (void)initView {
    // different insets
    self.itemsInsets = UIEdgeInsetsMake(4.0, 4.0, 4.0, 4.0);
    self.itemInterspacing = 4.0;
    [self updateLayoutSizes];
    
    // first
    self.avaliablePreviewCell = YES;
    
    // create collection view
    [self appendCollectionView];
    
    // register classes
    [self.collectionView registerNib:[UINib nibWithNibName:@"DMPhotoThumbsPhotoCell" bundle:nil] forCellWithReuseIdentifier:DMPhotoThumbsPhotoCell_ID];
    [self.collectionView registerNib:[UINib nibWithNibName:@"DMPhotoThumbsVizorCell" bundle:nil] forCellWithReuseIdentifier:DMPhotoThumbsVizorCell_ID];
    
    // data items
    [self prepareDataItems];
    [self.collectionView reloadData];
}

- (void)appendCollectionView {
    //frame
    CGRect frame = CGRectMake(0.0, 0.0, self.bounds.size.width, self.bounds.size.height);
    
    // layout
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    // create
    UICollectionView *collecitonView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
    collecitonView.backgroundColor = [UIColor clearColor];
    collecitonView.translatesAutoresizingMaskIntoConstraints = NO;
    collecitonView.delegate = self;
    collecitonView.dataSource = self;
    collecitonView.contentInset = self.itemsInsets;
    collecitonView.showsHorizontalScrollIndicator = NO;
    
    // store
    self.collectionView = collecitonView;
    
    // add to scene
    [self addSubview:collecitonView];
    
    // add constraints
    NSDictionary *views = @{ @"view" : collecitonView };
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:views]];

}

#pragma mark - Data items

- (void)prepareDataItems {
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    
    [library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (group == nil) return ;
        
        NSInteger maxCount = 100;
        NSInteger numberOfAssets = group.numberOfAssets;
        NSInteger startOffset = 0;
        NSInteger length = MIN(maxCount, numberOfAssets);
        if (numberOfAssets > maxCount) {
            startOffset = numberOfAssets - length;
        }
        
        // create array
        NSMutableArray *items = [NSMutableArray arrayWithCapacity:maxCount];
        
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(startOffset, length)];
        [group enumerateAssetsAtIndexes:indexSet options:NSEnumerationReverse usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            if (result == nil) return ;
            
            DMPhotoThumbsModel *model = [[DMPhotoThumbsModel alloc] init];
            UIImage *image = [UIImage imageWithCGImage: result.thumbnail];
            model.image = image;
            
            [items addObject:model];
        }];
        
        self.dataItems = items;
        [self.collectionView reloadData];
        
    } failureBlock:^(NSError *error) {
        
        NSLog(@"enumerate error: %@", error);
    }];
    
    self.selectedItems = [NSMutableDictionary dictionaryWithCapacity:10];
}

#pragma mark - Layout setup

- (void)updateLayoutSizes {
    CGFloat itemHeight = self.bounds.size.height - self.itemsInsets.top - self.itemsInsets.bottom;
    
    self.itemSize = CGSizeMake(itemHeight, itemHeight);
}

#pragma mark - Data items

- (DMPhotoThumbsModel *)modelByIndexPath:(NSIndexPath *)indexPath {
    NSInteger index = [self indexOfItemByIndexPath:indexPath];
    
    return [self.dataItems objectAtIndex:index];
}

- (NSInteger)indexOfItemByIndexPath:(NSIndexPath *)indexPath {
    NSInteger offset = 0;
    if (self.avaliablePreviewCell) {
        offset = -1;
    }
    
    NSInteger index = indexPath.row + offset;
    
    return index;
}

- (NSString *)keyForItemByIndexPath:(NSIndexPath *)indexPath {
    NSInteger index = [self indexOfItemByIndexPath:indexPath];
    
    return [NSString stringWithFormat:@"%ld", (long)index];
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return self.itemInterspacing;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.itemSize;
}

#pragma mark - UICollectionViewDataSource, UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger offset = 0;
    if (self.avaliablePreviewCell) {
        offset = 1;
    }
    
    if (self.dataItems == nil) return offset;
    
    return [self.dataItems count] + offset;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    // check for vizor
    if (self.avaliablePreviewCell && indexPath.row == 0) {
        DMPhotoThumbsVizorCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:DMPhotoThumbsVizorCell_ID forIndexPath:indexPath];
        
        return cell;
    }
    
    DMPhotoThumbsModel *model = [self modelByIndexPath:indexPath];
    
    // weak self
    __weak typeof (self) weakSelf = self;
    
    DMPhotoThumbsPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:DMPhotoThumbsPhotoCell_ID forIndexPath:indexPath];
    [cell updateCellWithModel:model];
    cell.checkedBlock = ^(BOOL checked) {
        [weakSelf afterCheckedItem:checked atIndexPath:indexPath];
        
    };
    
    // selected state
    NSString *key = [self keyForItemByIndexPath:indexPath];
    BOOL checked = ([self.selectedItems objectForKey:key]) ? YES : NO;
    [cell setCellChecked:checked];
    
    return cell;
}

- (void)afterCheckedItem:(BOOL)checked atIndexPath:(NSIndexPath *)indexPath {
    NSInteger index = [self indexOfItemByIndexPath:indexPath];
    
    NSString *key = [self keyForItemByIndexPath:indexPath];
    if (checked) {
        [self.selectedItems setObject:key forKey:key];
    } else {
        [self.selectedItems removeObjectForKey:key];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(dmPhotoThumbs:updateIemAtIndex:asCheck:)]) {
        [self.delegate dmPhotoThumbs:self updateIemAtIndex:index asCheck:checked];
    }
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"tap at index");
}

#pragma mark - Checked

- (NSInteger)countCheckedItems {
    if (self.selectedItems == nil) return 0;
    
    return [self.selectedItems count];
}

@end
