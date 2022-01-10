# SNTabBarDemo

Cool TabBar

## How To Use
不需要大量代码的改动，让你的工程拥有炫酷的TabBar效果。支持纯代码和StoryBoard工程。

引入SNTabBarController，将原工程 UITabBarController 改为 SNTabBarController来初始化 即可。

```
SNTabBar *tabBar = [[SNTabBar alloc] initWithNativeTabBar:self.tabBar];
tabBar.delegate = self;
tabBar.selectedIndex = self.selectedIndex;
tabBar.backgroundImage = [UIImage imageNamed:@"bg_image"];
tabBar.barTintColor = [UIColor redColor];
tabBar.selectionIndicatorColors =@[
          (id)[UIColor colorWithRed:0 green:1 blue:1 alpha:1.00].CGColor,
          (id)[UIColor colorWithRed:0.92 green:0.42 blue:0.67 alpha:1.00].CGColor];
tabBar.items = [newTabBarItems copy];
```

## Picture Show
![CoolTabBar](https://user-images.githubusercontent.com/7598376/148808370-562605c4-7249-4bbf-848b-dae75d5f40cb.gif)
