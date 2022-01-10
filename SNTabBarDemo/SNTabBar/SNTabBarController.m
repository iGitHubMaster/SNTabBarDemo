//
//  SNTabBarController.m
//  SNTabBarDemo
//
//  Created by ShawnWong on 2021/12/28.
//

#import "SNTabBarController.h"
#import "SNTabBar.h"

@interface SNTabBarController ()

@end

@implementation SNTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // default selected 0
    self.selectedIndex = 0;
    
    if(self.viewControllers.count){
        [self setupCustomTabBar];
    }
}

#pragma mark - Public
/**
 * 添加一个子控制器构造器
 * @param title 文字
 * @param image 图片
 * @param selectedImage 选中时的图片
 */
- (void)setupChildVc:(UIViewController *)vc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self addChildViewController:nav];
    
    // 设置子控制器的tabBarItem
    nav.title = title;
    nav.tabBarItem.image = [UIImage imageNamed:image];
    nav.tabBarItem.selectedImage = [UIImage imageNamed:selectedImage];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    for (id subV in self.tabBar.subviews) {
        if (![subV isKindOfClass:[SNTabBar class]]) {
            [subV removeFromSuperview];
        }
    }
}

#pragma mark - Private

//  TabBar Configs
- (void) setupCustomTabBar {
    
    if(self.tabBar.items){
        NSMutableArray *newTabBarItems = [NSMutableArray arrayWithCapacity:[self.tabBar.items count]];
        for (UITabBarItem *origTabBarItem in self.tabBar.items) {
            SNTabBarItem *newTabBarItem = [[SNTabBarItem alloc] initWithImage:origTabBarItem.image
                                                                selectedImage:origTabBarItem.selectedImage];
            [newTabBarItems addObject:newTabBarItem];
        }
        
        SNTabBar *tabBar = [[SNTabBar alloc] initWithNativeTabBar:self.tabBar];
        tabBar.delegate = self;
        tabBar.selectedIndex = self.selectedIndex;
        tabBar.backgroundImage = [UIImage imageNamed:@"bg_image"];
//        tabBar.barTintColor = [UIColor redColor];
        tabBar.selectionIndicatorColors =@[
            (id)[UIColor colorWithRed:0 green:1 blue:1 alpha:1.00].CGColor,
            (id)[UIColor colorWithRed:0.92 green:0.42 blue:0.67 alpha:1.00].CGColor];
        tabBar.items = [newTabBarItems copy];
        [self.tabBar addSubview:tabBar];
    }
}

#pragma mark - SNTabBarDelegate
- (void)sn_tabBar:(SNTabBar *)tabBar didSelectItem:(SNTabBarItem *)item {
    self.selectedIndex = tabBar.selectedIndex;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
