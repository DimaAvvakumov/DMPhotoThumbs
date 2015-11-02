//
//  DMPhotoThumbs.m
//  DMPhotoThumbs
//
//  Created by Avvakumov Dmitry on 22.09.15.
//  Copyright (c) 2015 Dmitry Avvakumov. All rights reserved.
//

#import "DMPhotoThumbs.h"

#import <AssetsLibrary/AssetsLibrary.h>

#import "DMPhotoThumbsStyleKit.h"

#import "DMPhotoThumbsPhotoCell.h"
#import "DMPhotoThumbsVizorCell.h"

@interface DMPhotoThumbs() <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) UICollectionView *collectionView;

@property (strong, nonatomic) NSArray *dataItems;

@property (assign, nonatomic) CGSize itemSize;

@property (strong, nonatomic) NSMutableIndexSet *selectedItems;

@property (strong, nonatomic) ALAssetsLibrary *assetLibrary;

// cell data
@property (strong, nonatomic) UIImage *checkOnImage;
@property (strong, nonatomic) UIImage *checkOffImage;

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
    self.selectedItems = [[NSMutableIndexSet alloc] init];
    
    // cell apereance
    self.checkOnImage = [DMPhotoThumbsStyleKit imageOfCheckOnIcon];
    self.checkOffImage = [DMPhotoThumbsStyleKit imageOfCheckOffIcon];
    
    // create collection view
    [self appendCollectionView];
    
    // register classes
    [self.collectionView registerNib:[UINib nibWithNibName:@"DMPhotoThumbsPhotoCell" bundle:nil] forCellWithReuseIdentifier:DMPhotoThumbsPhotoCell_ID];
    [self.collectionView registerNib:[UINib nibWithNibName:@"DMPhotoThumbsVizorCell" bundle:nil] forCellWithReuseIdentifier:DMPhotoThumbsVizorCell_ID];
    
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (newSuperview == nil) return;
    
    // data items
    [self prepareDataItems];
    [self.collectionView reloadData];
}

- (void)awakeFromNib {
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
    ALAssetsLibrary *library = nil;
    
    // ask data source for library
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(assetLibraryForDMPhotoThumbs:)]) {
        library = [self.dataSource assetLibraryForDMPhotoThumbs:self];
    }
    
    // check library for nil and if nil create one
    if (library == nil) {
        library = [[ALAssetsLibrary alloc] init];
    }
    
    // store library for future asset parsing
    // without this asset always return failure
    self.assetLibrary = library;
    
    // iterate by library for parsing groups
    // we are interests for one group - "saved photos"
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
            
//            DMPhotoThumbsModel *model = [[DMPhotoThumbsModel alloc] init];
//            UIImage *image = [UIImage imageWithCGImage: result.thumbnail];
//            model.image = image;
            
            [items addObject:result];
        }];
        
        self.dataItems = items;
        [self.collectionView reloadData];
        
    } failureBlock:^(NSError *error) {
        
        NSLog(@"enumerate error: %@", error);
    }];
    
}

#pragma mark - Layout setup

- (void)updateLayoutSizes {
    CGFloat itemHeight = self.bounds.size.height - self.itemsInsets.top - self.itemsInsets.bottom;
    
    self.itemSize = CGSizeMake(itemHeight, itemHeight);
}

#pragma mark - Data items

- (ALAsset *)modelByIndexPath:(NSIndexPath *)indexPath {
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
    
    ALAsset *model = [self modelByIndexPath:indexPath];
    
    // weak self
    __weak typeof (self) weakSelf = self;
    
    DMPhotoThumbsPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:DMPhotoThumbsPhotoCell_ID forIndexPath:indexPath];
    [cell updateCellWithModel:model];
    [cell.selectButton setImage:self.checkOffImage forState:UIControlStateNormal];
    [cell.selectButton setImage:self.checkOnImage forState:UIControlStateSelected];
    cell.checkedBlock = ^(BOOL checked) {
        [weakSelf afterCheckedItem:checked atIndexPath:indexPath];
    };
    
    // selected state
    NSInteger index = [self indexOfItemByIndexPath:indexPath];
    BOOL checked = [self.selectedItems containsIndex:index];
    [cell setCellChecked:checked];
    
    return cell;
}

- (void)afterCheckedItem:(BOOL)checked atIndexPath:(NSIndexPath *)indexPath {
    NSInteger index = [self indexOfItemByIndexPath:indexPath];
    
    if (checked) {
        [self.selectedItems addIndex:index];
    } else {
        [self.selectedItems removeIndex:index];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(dmPhotoThumbs:updateIemAtIndex:asCheck:)]) {
        [self.delegate dmPhotoThumbs:self updateIemAtIndex:index asCheck:checked];
    }
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger index = [self indexOfItemByIndexPath:indexPath];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(dmPhotoThumbs:tapItemAtIndex:)]) {
        [self.delegate dmPhotoThumbs:self tapItemAtIndex:index];
    }
}

#pragma mark - Cell appereance

- (void) setCheckImage:(UIImage *)image forState:(UIControlState)controlState {
    if (controlState == UIControlStateNormal) {
        self.checkOffImage = (image)?:[DMPhotoThumbsStyleKit imageOfCheckOffIcon];
    }
    if (controlState == UIControlStateSelected) {
        self.checkOnImage = (image)?:[DMPhotoThumbsStyleKit imageOfCheckOnIcon];
    }
}

#pragma mark - Items data

- (NSUInteger) countOfItems {
    if (self.dataItems == nil) return 0;
    
    return [self.dataItems count];
}

- (NSArray *) items {
    if (self.dataItems == nil) return nil;
    
    return self.dataItems;
}

- (NSInteger)countCheckedItems {
    if (self.selectedItems == nil) return 0;
    
    return [self.selectedItems count];
}

- (NSIndexSet *) checkedItems {
    if (self.selectedItems == nil) return nil;
    
    return self.selectedItems;
}

@end
