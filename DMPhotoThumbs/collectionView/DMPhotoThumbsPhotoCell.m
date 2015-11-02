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

//- (void)awakeFromNib {
//    
//}

- (void) updateCellWithModel:(ALAsset *)model {
    UIImage *image = [UIImage imageWithCGImage: model.thumbnail];
    
    self.imageView.image = image;
}

- (IBAction)selectAction:(UIButton*)sender {
    sender.selected = !sender.selected;
    
    if (self.checkedBlock) {
        self.checkedBlock( sender.selected );
    }
    
    CGAffineTransform t = CGAffineTransformMakeScale(1.25, 1.25);
    NSUInteger opt = UIViewAnimationOptionAutoreverse;
    if (!sender.selected) {
        sender.transform = CGAffineTransformMakeScale(0.8, 0.8);
        t = CGAffineTransformIdentity;
        opt = 0;
    }
    
    [UIView animateWithDuration:0.15 delay:0.0 options:opt animations:^{
        sender.transform = t;
    } completion:^(BOOL finished) {
        if (finished) {
            [sender.layer removeAllAnimations];
            
            sender.transform = CGAffineTransformIdentity;
        }
    }];
    
}

- (void) setCellChecked:(BOOL)checked {
    self.selectButton.selected = checked;
}


@end
