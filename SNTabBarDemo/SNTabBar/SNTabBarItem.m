//
//  SNTabBarItem.m
//  SNTabBarDemo
//
//  Created by ShawnWong on 2022/1/5.
//

#import "SNTabBarItem.h"

@implementation SNTabBarItem

- (instancetype)initWithImage:(UIImage *)image selectedImage:(UIImage *)selectedImage {
    self = [SNTabBarItem buttonWithType:UIButtonTypeCustom];
    if (self) {
        self.imageInsets = UIEdgeInsetsMake(-49, 0, 0, 0);
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
//        if (@available(iOS 15.0, *)) {
//              UIButtonConfiguration
//        }else {
            [self setShowsTouchWhenHighlighted:NO];
//        }
#pragma clang diagnostic pop
        self.image = image;
        self.selectedImage = selectedImage;
    }
    return self;
}

- (void)setImage:(UIImage *)image {
    if (image) {
        _image = image;
        [self setImage:image forState:UIControlStateNormal];
    }
}

- (void)setSelectedImage:(UIImage *)selectedImage {
    if (selectedImage) {
        _selectedImage = selectedImage;
        [self setImage:selectedImage forState:UIControlStateSelected];
    }
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

    // UIButtonConfiguration
    if (selected) {
        [self setImageEdgeInsets:self.imageInsets];
    }else{
        [self setImageEdgeInsets:UIEdgeInsetsZero];
    }
#pragma clang diagnostic pop
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
