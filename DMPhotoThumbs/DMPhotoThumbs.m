//
//  DMPhotoThumbs.m
//  DMPhotoThumbs
//
//  Created by Avvakumov Dmitry on 22.09.15.
//  Copyright (c) 2015 Dmitry Avvakumov. All rights reserved.
//

#import "DMPhotoThumbs.h"

#import "DMPhotoThumbsPhotoCell.h"
#import "DMPhotoThumbsVizorCell.h"

@interface DMPhotoThumbs() <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) UICollectionView *collectionView;

@property (strong, nonatomic) NSArray *dataItems;

@property (assign, nonatomic) CGSize itemSize;

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
    
    // dummy
    [self dummyData];
    [self.collectionView reloadData];
}

- (void)dummyData {
    NSMutableArray *dataItems = [NSMutableArray arrayWithCapacity:10];
    [dataItems addObject:[DMPhotoThumbsModel new]];
    [dataItems addObject:[DMPhotoThumbsModel new]];
    [dataItems addObject:[DMPhotoThumbsModel new]];
    [dataItems addObject:[DMPhotoThumbsModel new]];
    [dataItems addObject:[DMPhotoThumbsModel new]];
    [dataItems addObject:[DMPhotoThumbsModel new]];
    [dataItems addObject:[DMPhotoThumbsModel new]];
    [dataItems addObject:[DMPhotoThumbsModel new]];
    [dataItems addObject:[DMPhotoThumbsModel new]];
    [dataItems addObject:[DMPhotoThumbsModel new]];
    [dataItems addObject:[DMPhotoThumbsModel new]];
    [dataItems addObject:[DMPhotoThumbsModel new]];
    [dataItems addObject:[DMPhotoThumbsModel new]];
    
    self.dataItems = dataItems;
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
    
    // store
    self.collectionView = collecitonView;
    
    // add to scene
    [self addSubview:collecitonView];
    
    // add constraints
    NSDictionary *views = @{ @"view" : collecitonView };
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:views]];

}

#pragma mark - Layout setup

- (void)updateLayoutSizes {
    CGFloat itemHeight = self.bounds.size.height - self.itemsInsets.top - self.itemsInsets.bottom;
    
    self.itemSize = CGSizeMake(itemHeight, itemHeight);
}

#pragma mark - Data items

- (DMPhotoThumbsModel *)modelByIndexPath:(NSIndexPath *)indexPath {
    NSInteger offset = 0;
    if (self.avaliablePreviewCell) {
        offset = -1;
    }
    
    NSInteger index = indexPath.row + offset;
    
    return [self.dataItems objectAtIndex:index];
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
    
    DMPhotoThumbsPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:DMPhotoThumbsPhotoCell_ID forIndexPath:indexPath];
    [cell updateCellWithModel:model];
    
    return cell;
}

@end
