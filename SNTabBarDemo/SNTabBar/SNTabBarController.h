//
//  SNTabBarController.h
//  SNTabBarDemo
//
//  Created by ShawnWong on 2021/12/28.
//

#import <UIKit/UIKit.h>
#import "SNTabBar.h"
#import "SNTabBarItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface SNTabBarController : UITabBarController<SNTabBarDelegate>

/// 初始化ChildVC
/// @param vc ViewController
/// @param title navi Title
/// @param image item Normal Image
/// @param selectedImage item selectedImage
- (void)setupChildVc:(UIViewController *)vc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage;

@end

NS_ASSUME_NONNULL_END
