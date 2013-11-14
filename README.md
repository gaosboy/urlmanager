URLManager
====
URL Scheme为基础的NavigationController，让ViewController实现松耦合，不依赖

使用
====
URLManager提供两个NavigationController，一个WebViewController和一个基础ViewController，可单独使用也可结合使用。

UMViewController
----
URLManager的基础ViewController，使用URLManager需要以UMViewController代替UIViewController作为基类。

UMViewController可以使用URL初始化（方法如下）。但一般不直接使用，而是通过NavigationController的工厂方法。

```
- (id)initWithURL:(NSURL *)aUrl;
- (id)initWithURL:(NSURL *)aUrl query:(NSDictionary *)query;
```

通过URL打开新的ViewController过程中会触发以下方法

```
- (BOOL)shouldOpenViewControllerWithURL:(NSURL *)aUrl; // 是否继续打开
- (void)openedFromViewControllerWithURL:(NSURL *)aUrl; // 从哪里来
```

UMNavigator
----
UMNavigator是一个单例对象，可以监控当前显示的ViewController，并使用URL管理机制代替UINavigationController的push和pop机制。

#### 注册URL和ViewController的对应关系

```
    [[UMNavigator sharedNavigator] setViewControllersForKeysFromDictionary:@{@"nava":navA,                                                                             @"navb":navB}];
```

或

```
    [[UMNavigator sharedNavigator] setViewControllerName:@"UMDemoViewController"
                                                  forURL:@"demo"];
```

或

```
    UINavigationController *navC = [[UINavigationController alloc] initWithRootViewControllerURL:
                                    [[NSURL URLWithString:@"um://demo"]
                                     addParams:[NSDictionary dictionaryWithObjectsAndKeys:
                                                @"Demo1", @"title", nil]]];

    [[UMNavigator sharedNavigator] setViewController:navC forURL:@"navc"];
```

#### 初始化UMNavigationController

```
UMNavigationController * umNav = [[UMNavigationController alloc]
			initWithRootViewControllerURL:[[NSURL URLWithString:@"um://demo"]
									addParams:[NSDictionary dictionaryWithObjectsAndKeys:
												@"Demo", @"title", nil]]];
[self.window addSubView:umNav.view];
```

#### 打开新的ViewController

```
// 取代 [self.navigationController pushViewController: animated:];
[[UMNavigator sharedNavigator] openURL:[NSURL URLWithString:@"um://demo?title=NextDemo&param=value"]];
```

#### 调用openURL: 将会触发以下方法

在调用方Controller中会触发以下方法，返回YES则执行push效果

```
- (BOOL)shouldOpenViewControllerWithURL:(NSURL *)aUrl;
```

在被调用的ViewController中，触发以下方法

```
- (void)openedFromViewControllerWithURL:(NSURL *)aUrl;
```

UMSlideNavigationController
----
侧栏导航，与Path侧栏滑动类似的效果。

```
	UINavigationController * navA = [[UINavigationController alloc]
									initWithRootViewController:[[UIViewController alloc] init]];
	UMNavigationController * navB = [[UMNavigationController alloc]
									initWithRootViewControllerURL:[NSURL urlWithString:@"um://demo"]];

    self.navigator = [[UMDemoSlideNavViewController alloc] initWithItems:@[@[navA, navB], @[navA]]];
```
侧栏滑动即将出现和已经消失时，将会发送两个通知。

```
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:UMNotificationWillShow object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:UMNotificationHidden object:nil];
}
```

![侧栏演示](http://pic.yupoo.com/gaosboy_v/DjjltGAv/4w32w.png)

UMWebViewController
----
当使用URL管理ViewController过程中，如果出现http协议的URL则自动调用UMWebViewController，载入WebView
