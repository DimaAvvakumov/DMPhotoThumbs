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
@property (weak, nonatomic) IBOutlet UIButton *selectButton;

@end

@implementation DMPhotoThumbsPhotoCell

- (void)awakeFromNib {
    [self.selectButton setImage:self.checkOffImage forState:UIControlStateNormal];
    [self.selectButton setImage:self.checkOnImage forState:UIControlStateSelected];
}

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

- (UIImage *)checkOnImage {
    static UIImage *image = nil;
    
    if (image)
        return image;
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(30, 30), NO, 0.0f);
    [self drawCheckOn];
    
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage *)checkOffImage {
    static UIImage *image = nil;
    
    if (image)
        return image;
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(30, 30), NO, 0.0f);
    [self drawCheckOff];
    
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)drawCheckOn {
    
    //// check-on
    {
        UIColor *mainColor = [UIColor colorWithRed:38.0/255.0 green:180.0/255.0 blue:244.0/255.0 alpha:1.0];

        //// Shape Drawing
        UIBezierPath* shapePath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(4, 4, 22, 22)];
        [mainColor setFill];
        [shapePath fill];
        
        //// Checkmark Drawing
        UIBezierPath* checkmarkPath = [UIBezierPath bezierPath];
        [checkmarkPath moveToPoint: CGPointMake(9.75, 14.75)];
        [checkmarkPath addLineToPoint: CGPointMake(8.25, 16.25)];
        [checkmarkPath addLineToPoint: CGPointMake(12.25, 20.25)];
        [checkmarkPath addLineToPoint: CGPointMake(21.25, 11.75)];
        [checkmarkPath addLineToPoint: CGPointMake(19.75, 10.25)];
        [checkmarkPath addLineToPoint: CGPointMake(12.25, 17.25)];
        [checkmarkPath addLineToPoint: CGPointMake(9.75, 14.75)];
        [checkmarkPath closePath];
        checkmarkPath.miterLimit = 4;
        
        checkmarkPath.usesEvenOddFillRule = YES;
        
        [UIColor.whiteColor setFill];
        [checkmarkPath fill];
    }
    
}

- (void)drawCheckOff {
    
    //// Color Declarations
    UIColor* checkboxGrayColor = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0.239];
    
    //// CheckOffIcon
    {
        //// dark Drawing
        UIBezierPath* darkPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(4, 4, 22, 22)];
        [checkboxGrayColor setFill];
        [darkPath fill];
        
        
        //// dark-copy Drawing
        UIBezierPath* darkcopyPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(4, 4, 22, 22)];
        [UIColor.whiteColor setStroke];
        darkcopyPath.lineWidth = 1;
        [darkcopyPath stroke];
    }
    
}


@end
