//
//  DMPhotoThumbsVizorCell.h
//  DMPhotoThumbs
//
//  Created by Avvakumov Dmitry on 22.09.15.
//  Copyright (c) 2015 Dmitry Avvakumov. All rights reserved.
//

#import <UIKit/UIKit.h>

#define DMPhotoThumbsVizorCell_ID @"DMPhotoThumbsVizorCell_ID"

@interface DMPhotoThumbsVizorCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *pickImageView;

- (void)startCapture;
- (void)stopCapture;

@end
