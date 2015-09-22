//
//  DMPhotoThumbs.m
//  DMPhotoThumbs
//
//  Created by Avvakumov Dmitry on 22.09.15.
//  Copyright (c) 2015 Dmitry Avvakumov. All rights reserved.
//

#import "DMPhotoThumbs.h"

#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>

#import "DMPhotoThumbsPhotoCell.h"
#import "DMPhotoThumbsVizorCell.h"

@interface DMPhotoThumbs() <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) UICollectionView *collectionView;

@property (strong, nonatomic) NSArray *dataItems;

@property (assign, nonatomic) CGSize itemSize;

@property (nonatomic) dispatch_queue_t sessionQueue;

@property (strong, nonatomic) AVCaptureSession *captureSession;
@property (assign, nonatomic) BOOL deviceAuthorized;

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
    
    // prepare preview cell
    [self preparePreviewCell];
    
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

#pragma mark - Preview cell

- (void)preparePreviewCell {
    // Create the AVCaptureSession
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    self.captureSession = session;
    
    // Setup the preview view
    // [[self previewView] setSession:session];
    
    // Check for device authorization
    [self checkDeviceAuthorizationStatus];
    
    // In general it is not safe to mutate an AVCaptureSession or any of its inputs, outputs, or connections from multiple threads at the same time.
    // Why not do all of this on the main queue?
    // -[AVCaptureSession startRunning] is a blocking call which can take a long time. We dispatch session setup to the sessionQueue so that the main queue isn't blocked (which keeps the UI responsive).
    
    dispatch_queue_t sessionQueue = dispatch_queue_create("session queue", DISPATCH_QUEUE_SERIAL);
    [self setSessionQueue:sessionQueue];
    
    dispatch_async(sessionQueue, ^{
        NSError *error = nil;
        
        AVCaptureDevice *videoDevice = [self deviceWithMediaType:AVMediaTypeVideo preferringPosition:AVCaptureDevicePositionBack];
        AVCaptureDeviceInput *videoDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&error];
        
        if (error) {
            NSLog(@"%@", error);
            
            return ;
        }
        
        if ([session canAddInput:videoDeviceInput]) {
            [session addInput:videoDeviceInput];
            // [self setVideoDeviceInput:videoDeviceInput];
            
//            dispatch_async(dispatch_get_main_queue(), ^{
//                // Why are we dispatching this to the main queue?
//                // Because AVCaptureVideoPreviewLayer is the backing layer for AVCamPreviewView and UIView can only be manipulated on main thread.
//                // Note: As an exception to the above rule, it is not necessary to serialize video orientation changes on the AVCaptureVideoPreviewLayer’s connection with other session manipulation.
//                
//                UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
//                [[(AVCaptureVideoPreviewLayer *)[[self previewView] layer] connection] setVideoOrientation:(AVCaptureVideoOrientation)interfaceOrientation];
//            });
        }
    });
}

- (AVCaptureDevice *)deviceWithMediaType:(NSString *)mediaType preferringPosition:(AVCaptureDevicePosition)position {
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:mediaType];
    AVCaptureDevice *captureDevice = [devices firstObject];
    
    for (AVCaptureDevice *device in devices)
    {
        if ([device position] == position)
        {
            captureDevice = device;
            break;
        }
    }
    
    return captureDevice;
}

- (void)checkDeviceAuthorizationStatus {
    NSString *mediaType = AVMediaTypeVideo;
    
    [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
        if (granted) {
            //Granted access to mediaType
            [self setDeviceAuthorized:YES];
        } else {
            
            //Not granted access to mediaType
            dispatch_async(dispatch_get_main_queue(), ^{
                [[[UIAlertView alloc] initWithTitle:@"Warning!"
                                            message:@"App doesn't have permission to use Camera, please change privacy settings"
                                           delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil] show];
                [self setDeviceAuthorized:NO];
            });
        }
    }];
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
        [cell setSession:self.captureSession];
        
        return cell;
    }
    
    DMPhotoThumbsModel *model = [self modelByIndexPath:indexPath];
    
    DMPhotoThumbsPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:DMPhotoThumbsPhotoCell_ID forIndexPath:indexPath];
    [cell updateCellWithModel:model];
    
    return cell;
}

@end
