//
//  DMPhotoThumbsPhotoCell.m
//  DMPhotoThumbs
//
//  Created by Avvakumov Dmitry on 22.09.15.
//  Copyright (c) 2015 Dmitry Avvakumov. All rights reserved.
//

#import "DMPhotoThumbsPhotoCell.h"

@interface DMPhotoThumbsPhotoCell()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation DMPhotoThumbsPhotoCell

- (void) updateCellWithModel:(DMPhotoThumbsModel *)model {
    self.imageView.image = model.image;
}

@end
