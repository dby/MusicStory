//
//  MSMenuViewController.m
//  MusicStory
//
//  Created by sys on 16/6/14.
//  Copyright © 2016年 sys. All rights reserved.
//

#import "MSMenuViewController.h"

@interface MSMenuViewController ()

@property (nonatomic, assign) CGFloat menuWith;
@property (nonatomic, assign) CGFloat animationDuration;

@end

@implementation MSMenuViewController

@synthesize type = _type;

#pragma mark - life cycle

- (void)viewDidLoad {
    debugMethod();
    [super viewDidLoad];
    
    [self buildComponents];
}

- (void)viewWillAppear:(BOOL)animated {
    debugMethod();
    [super viewWillAppear:animated];
    
    // 添加通知。当点击菜单按钮时
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(leftMenuShowAnimate) name:NOTIFY_SHOWMENU object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(leftMenuHiddenAnimate) name:NOTIFY_HIDDEMENU object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(leftMenuSetupBackColor:) name:NOTIFY_SETUPBG object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(leftMenuSetupCenterView:) name:NOTIFY_SETUPCENTERVIEW object:nil];
    
    [self.view bringSubviewToFront:self.centerController.view];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewWillDisappear:(BOOL)animated {
    debugMethod();
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - init

/**
 初始化菜单控制器
 
 - parameter centerController: 中间的控制器
 - parameter leftController:   侧滑菜单的控制器
 
 */
- (instancetype)initWithCenterController:(MSBaseNavController *)centerController leftController:(MSBaseNavController *)leftController {
    debugMethod();
    self = [super init];
    if (self) {
        self.view.backgroundColor = UI_COLOR_APPNORMAL;

        self.centerController = centerController;
        self.homeController = (MSHomeViewController *)centerController.viewControllers.firstObject;
        self.leftController = leftController;
        // 初始化左边的控制器
        [self addLeftController];
        // 初始化中间的控制器
        [self addCenterController];
        // 添加覆盖层
        [self addCover];
        // 添加手势
        UIPanGestureRecognizer *leftPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(leftMenuDidDrag:)];
        [self.leftController.view addGestureRecognizer:leftPan];
    }
    return self;
}

#pragma setter or getter

-(void)setType:(MenuViewControllerType)type {
    debugMethod();
    _type = type;
    
    if (_type == MenuViewControllerTypeHome) {
        
        if ([self.currentController isKindOfClass:[MSHomeViewController class]]) {
            //[self leftMenuHiddenAnimate];
            return;
        }
        
        [self.currentController.view removeFromSuperview];
        [self.currentController removeFromParentViewController];
        self.currentController = nil;
        
        if (self.homeController == nil) {
            self.homeController = [[MSHomeViewController alloc] init];
        }
        
        [self.centerController addChildViewController:self.homeController];
        self.homeController.view.frame  = self.view.bounds;
        self.centerController.view.x    = self.menuWith;
        self.currentController          = self.homeController;
        
    } else if (MenuViewControllerTypeFindApp) {
        
    }
    [self.centerController.view addSubview:self.currentController.view];
    //[self leftMenuHiddenAnimate];
    [self leftMenuShowAnimate];
}

#pragma mark - build

- (void)buildComponents {
    
    debugMethod();
    self.menuWith           = 0.855 * SCREEN_WIDTH;
    self.animationDuration  = 0.3;
    
    self.type = MenuViewControllerTypeHome;
}

#pragma mark - private function

/**
 初始化中间控制器 添加中间的控制器
 */
- (void)addCenterController {
    debugMethod();
    // 默认选中homecontroller
    self.homeController.view.frame = self.view.bounds;
    [self.centerController addChildViewController:self.homeController];
    [self.centerController.view addSubview:self.homeController.view];
    
    [self.view addSubview:self.centerController.view];
    [self addChildViewController:self.centerController];
    self.currentController = self.homeController;
}

/**
 初始化左边菜单控制器 添加左边的控制器
 */
- (void) addLeftController {
    debugMethod();
    self.leftController.view.frame      = CGRectMake(0, 0, _menuWith, SCREEN_HEIGHT);
    self.leftController.view.transform  = CGAffineTransformMakeScale(0.5, 0.5);
    [self.view addSubview:self.leftController.view];
    [self addChildViewController:self.leftController];
}

/**
 添加覆盖层按钮
 */
- (void)addCover {
    debugMethod();
    UIWindow *cover = [[UIWindow alloc] initWithFrame:self.centerController.view.frame];
    // 拖拽覆盖层事件
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(leftMenuDidDrag:)];
    cover.backgroundColor = [UIColor colorWithRed:254/255.0 green:254/255.0 blue:254/255.0 alpha:0.02];
    [cover addGestureRecognizer:pan];
    self.cover = cover;
    [self.centerController.view addSubview:cover];
    // 点击覆盖层事件
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(leftMenuHiddenAnimate)];
    [cover addGestureRecognizer:tap];
    
    [self.view bringSubviewToFront:cover];
}

/**
 在中间控制器手势操作是调用
 
 - parameter pan:
 */
- (void)leftMenuDidDrag:(UIPanGestureRecognizer *)pan {
    debugMethod();
    // 拿到手指在屏幕中的位置
    CGPoint point = [pan translationInView:pan.view];
    
    // 如果手指取消了或者结束
    if (pan.state == UIGestureRecognizerStateCancelled || pan.state == UIGestureRecognizerStateEnded) {
        [self leftMenuHiddenAnimate];
    } else {
        // 正在拖拽的状态
        
        // 让左边控制器的x值跟手拖动
        self.centerController.view.x += point.x;
        [pan setTranslation:CGPointZero inView:self.centerController.view];
        // 如果拖动x的值小于0 就不让他拖了
        if (self.centerController.view.x > _menuWith) {
            self.centerController.view.x = _menuWith;
            self.cover.hidden = false;
        } else if (self.centerController.view.x <= 0) {
            self.centerController.view.x = 0;
            self.cover.hidden = true;
        }
    }
}

- (void)coverButtonDidPan:(UIPanGestureRecognizer *)pan {
    
}

//MARK: 给外部调用 =========================
/**
 显示左边菜单动画
 */
- (void)leftMenuShowAnimate {
    debugMethod();
    [UIView animateWithDuration:_animationDuration animations:^{
        self.centerController.view.x = self.menuWith;
        self.leftController.view.transform = CGAffineTransformMakeScale(1.0, 1.0);
        self.cover.hidden = false;
    }];
}

/**
 *  隐藏左边菜单动画
 */
- (void)leftMenuHiddenAnimate {
    
    debugMethod();
    [UIView animateWithDuration:_animationDuration animations:^{
        self.centerController.view.x = 0;
        self.cover.hidden = true;
    } completion:^(BOOL finished) {
        self.leftController.view.transform = CGAffineTransformMakeScale(0.5, 0.5);
    }];
}

- (void)leftMenuSetupBackColor:(NSNotification *)notify {
    debugMethod();
    UIColor *bg = (UIColor *)notify.object;
    self.view.backgroundColor = bg;
}

- (void)leftMenuSetupCenterView:(NSNotification *)notify {
    
    debugMethod();
    /*
    NSString *type = (NSString *)notify.object;
    if ([type isEqualToString:NOTIFY_OBJ_TODAY]) {
        
    }
    switch type {
    case NOTIFY_OBJ_TODAY,NOTIFY_OBJ_RECOMMEND,NOTIFY_OBJ_ARTICLE :
        self.type = .MenuViewControllerTypeHome
    case NOTIFY_OBJ_FINDAPP:
        UIView.animateWithDuration(animationDuration, animations: { () -> Void in
            self.view.backgroundColor = UI_COLOR_APPNORMAL
        })
        self.type = .MenuViewControllerTypeFindApp
    default:
        self.type = .MenuViewControllerTypeHome
        
    }
     */
}

@end
