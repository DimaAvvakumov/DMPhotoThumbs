//
//  ViewController.m
//  DMPhotoThumbs
//
//  Created by Avvakumov Dmitry on 22.09.15.
//  Copyright (c) 2015 Dmitry Avvakumov. All rights reserved.
//

#import "ViewController.h"

#import <AssetsLibrary/AssetsLibrary.h>

#import "DMPhotoThumbs.h"

@interface ViewController () <DMPhotoThumbsDelegate, DMPhotoThumbsDataSource>

@property (weak, nonatomic) IBOutlet DMPhotoThumbs *photoThumbs;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    
//    UIImage *image = [DMPhotoThumbsStyleKit imageOfCheckOnIcon];
//    [_photoThumbs setPickPhotoIcon:image];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Caption

- (void)updateCaption {
    NSInteger count = [self.photoThumbs countCheckedItems];
    
    if (count == 0) {
        self.captionLabel.text = @"No items selected";
    } else {
        self.captionLabel.text = [NSString stringWithFormat:@"Selected items: %ld", (long)count];
    }
}

- (IBAction)clearAction:(UIButton *)sender {
    [self.photoThumbs clearCheckedItems];
    
    [self updateCaption];
}

- (IBAction)startCaptureAction:(UIButton *)sender {
    [self.photoThumbs prepareForShowing];
}

- (IBAction)stopCaptureAction:(UIButton *)sender {
    [self.photoThumbs prepareForHidding];
}

#pragma mark - DMPhotoThumbsDelegate, DMPhotoThumbsDataSource

- (ALAssetsLibrary*)assetLibraryForDMPhotoThumbs:(DMPhotoThumbs *)view {
    return nil;
  //  return [[ALAssetsLibrary alloc] init];
}

- (ALAssetsFilter *)dmPhotoThumbsAssetFilter:(DMPhotoThumbs *)view {
    return [ALAssetsFilter allPhotos];
}

- (void)dmPhotoThumbs:(DMPhotoThumbs *)view updateIemAtIndex:(NSInteger)index asCheck:(BOOL)check {
    [self updateCaption];
}

- (void)dmPhotoThumbs:(DMPhotoThumbs *)view tapItemAtIndex:(NSInteger)index {
    ALAsset *asset = [view.items objectAtIndex:index];
    CGImageRef origCGImage = [[asset defaultRepresentation] fullResolutionImage];

    self.imageView.image = [UIImage imageWithCGImage: origCGImage];
}

@end
