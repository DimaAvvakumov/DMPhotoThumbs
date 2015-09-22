//
//  DMPhotoThumbsPreviewView.h
//  DMPhotoThumbs
//
//  Created by Avvakumov Dmitry on 22.09.15.
//  Copyright © 2015 Dmitry Avvakumov. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AVCaptureSession;

@interface DMPhotoThumbsPreviewView : UIView

@property (nonatomic) AVCaptureSession *session;

@end
