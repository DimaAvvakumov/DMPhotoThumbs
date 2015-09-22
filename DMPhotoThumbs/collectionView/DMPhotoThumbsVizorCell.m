//
//  DMPhotoThumbsVizorCell.m
//  DMPhotoThumbs
//
//  Created by Avvakumov Dmitry on 22.09.15.
//  Copyright (c) 2015 Dmitry Avvakumov. All rights reserved.
//

#import "DMPhotoThumbsVizorCell.h"

#import <AVFoundation/AVFoundation.h>

#import "DMPhotoThumbsPreviewView.h"

@interface DMPhotoThumbsVizorCell()

@property (weak, nonatomic) IBOutlet DMPhotoThumbsPreviewView *previewView;

@end

@implementation DMPhotoThumbsVizorCell

- (void)awakeFromNib {
    
}

- (void)setSession:(AVCaptureSession *)session {
    [self.previewView setSession:session];
}


@end
