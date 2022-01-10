//
//  SNTabBar.h
//  SNTabBarDemo
//
//  Created by ShawnWong on 2021/12/28.
//

#import <UIKit/UIKit.h>
#import "SNTabBarItem.h"

@protocol SNTabBarDelegate;

NS_ASSUME_NONNULL_BEGIN

@interface SNTabBar : UIView

- (instancetype)initWithNativeTabBar:(UITabBar *)tabBar;

@property(nullable, nonatomic, copy) NSArray<SNTabBarItem *> *items;        // get/set visible UITabBarItems. default is nil. changes not animated. shown in order

@property(nullable, nonatomic, weak) id<SNTabBarDelegate> delegate;     // weak reference. default is nil

@property(nonatomic, strong) UIColor *barTintColor;  // default is whiteColor

/* The background image will be fill
 */
@property(nullable, nonatomic, strong) UIImage *backgroundImage;

/*
 Default is no. with alpha = .75
 */
@property(nonatomic,getter=isTranslucent) BOOL translucent;

/* The selection indicator image is drawn on top of the tab bar, behind the bar item icon.
 The array of CGColorRef objects defining the color of each gradient
  * stop. Defaults to nil. Animatable.  max limit 2
 */
@property(nullable, nonatomic, copy) NSArray<UIColor *> *selectionIndicatorColors; // gradient colors

@property (nonatomic, assign) NSInteger selectedIndex; // default selected index 0

@end


@protocol SNTabBarDelegate<NSObject>
@optional

- (void)sn_tabBar:(SNTabBar *)tabBar didSelectItem:(SNTabBarItem *)item; // called when a new view is selected by the user (but not programmatically)

@end

NS_ASSUME_NONNULL_END
