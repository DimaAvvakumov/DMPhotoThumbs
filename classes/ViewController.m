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
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

#pragma mark - DMPhotoThumbsDelegate, DMPhotoThumbsDataSource

- (ALAssetsLibrary*)assetLibraryForDMPhotoThumbs:(DMPhotoThumbs *)view {
    return nil;
  //  return [[ALAssetsLibrary alloc] init];
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
