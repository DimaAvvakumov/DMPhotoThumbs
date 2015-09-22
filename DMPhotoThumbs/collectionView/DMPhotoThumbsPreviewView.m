//
//  DMPhotoThumbsPreviewView.m
//  DMPhotoThumbs
//
//  Created by Avvakumov Dmitry on 22.09.15.
//  Copyright © 2015 Dmitry Avvakumov. All rights reserved.
//

#import "DMPhotoThumbsPreviewView.h"

#import <AVFoundation/AVFoundation.h>

@implementation DMPhotoThumbsPreviewView

+ (Class)layerClass {
    return [AVCaptureVideoPreviewLayer class];
}

- (AVCaptureSession *)session {
    return [(AVCaptureVideoPreviewLayer *)[self layer] session];
}

- (void)setSession:(AVCaptureSession *)session {
    AVCaptureVideoPreviewLayer *layer = (AVCaptureVideoPreviewLayer *) [self layer];
    [layer setSession:session];
    
    layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
}

@end
