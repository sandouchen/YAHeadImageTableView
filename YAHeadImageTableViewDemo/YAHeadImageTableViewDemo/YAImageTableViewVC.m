//
//  YAImageTableViewVC.m
//  YAHeadImageTableViewDemo
//
//  Created by yinyao on 2017/3/13.
//  Copyright © 2017年 yinyao. All rights reserved.
//
//  GitHub: https://github.com/yaomars/YAHeadImageTableView

#import "YAImageTableViewVC.h"
#import "UINavigationBar+AlphaAnimation.h"
#import "YYImage.h"
#import "UIView+Extension.h"
#import "CommonMacro.h"

@interface YAImageTableViewVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) UIImageView *headerImageView;
@property (nonatomic, weak) UILabel *titleLbl;

@property (nonatomic, assign) CGFloat headerView_height;
@property (nonatomic, assign) CGFloat navbar_change_point;
@property (nonatomic, assign) CGFloat introLbl_height;

@property (nonatomic, weak) UIView *headerView;
@property (nonatomic, weak) UILabel *introLbl;
@property (nonatomic, weak) UIButton *moreTextBtn;

@end

@implementation YAImageTableViewVC

static NSString *cellIdentifier = @"YAImageTableViewVCCell";

#pragma mark - 重写init
- (instancetype)init {

    self = [super init];
    if (self) {
        //
    }
    return self;
}

#pragma mark - 视图生命周期
/** 控制器销毁 */
- (void)dealloc {
    NSLog(@"YAImageTableViewVC -- dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    //初始化变量
    if (_imageTableViewStyle == YAImageTableViewStyleOne) {
        _headerView_height = 180.0f;
        _navbar_change_point = 50.0f;
    } else if (_imageTableViewStyle == YAImageTableViewStyleTwo) {
        _headerView_height = 340.0f;
        _navbar_change_point = 180.0f;
        _introLbl_height = 50.0f;
    }
    
    //初始化视图
    [self setupUI];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self scrollViewDidScroll:self.tableView];
}

- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];
    
    [self.navigationController.navigationBar ya_setBackgroundColor:[UIColor clearColor]];
}

- (void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];
    //还原导航栏
    [self.navigationController.navigationBar ya_reset];
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
}

#pragma mark - 初始化
/** 初始化视图 */
- (void)setupUI {
    
    self.view.backgroundColor = [UIColor whiteColor];

    //导航栏标题
    UILabel *titleLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 44)];
    titleLbl.text = _navbarTitle ? : @"默认标题";
    titleLbl.textColor = [UIColor clearColor];
    titleLbl.alpha = 0.0;
    self.navigationItem.titleView = titleLbl;
    self.titleLbl = titleLbl;
    
    //设置tableView
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.contentInset = UIEdgeInsetsMake(_headerView_height, 0, 0, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    self.tableView.rowHeight = 55.0f;
    
    //顶部视图设置
    NSString *imageName = nil;
    if (_imageTableViewStyle == YAImageTableViewStyleOne) {
        imageName = @"niconiconi@2x.gif";
        
        UIImageView *headerImageView = [[YYAnimatedImageView alloc]initWithFrame:CGRectMake(0, -_headerView_height, SCREENWIDTH, _headerView_height)];
        
        headerImageView.image = [YYImage imageNamed:imageName];
        headerImageView.contentMode = UIViewContentModeScaleAspectFill;
        headerImageView.clipsToBounds = YES;
        
        [self.tableView addSubview:headerImageView];
        self.headerImageView = headerImageView;
    } else if (_imageTableViewStyle == YAImageTableViewStyleTwo) {
        imageName = @"timg_test.jpeg";
        
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, -_headerView_height, SCREENWIDTH, _headerView_height)];
        headerView.backgroundColor = [UIColor whiteColor];
        
        [self.tableView addSubview:headerView];
        
        UIImageView *backgroundImageView = [[YYAnimatedImageView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 200)];
        backgroundImageView.image = [YYImage imageNamed:imageName];
        backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
        backgroundImageView.clipsToBounds = YES;
        
        [headerView addSubview:backgroundImageView];
        self.headerImageView = backgroundImageView;
        
        UILabel *introLbl = [[UILabel alloc]init];
        introLbl.origin = CGPointMake(10, 200 + 20);
        introLbl.width = SCREENWIDTH - 20;
        introLbl.height = _introLbl_height;
        introLbl.numberOfLines = 2;
        NSString *textString = @"郎咸平可说是全世界最活跃的中青年财务金融学家之一，更是极少的既深解国际金融学理论又关注亚洲金融问题的专家，他耗费相当的精力于大陆股市，为建立一个健康法制的中国股市而四处奔波，甚至不畏得罪各类利益集团，其智慧，其勇气，令人敬仰。\n郎咸平作品中的精辟观点产生广泛影响力，销售排行榜上曾居高不下，各位投资者不妨在关注郎咸平劲爆话题引发的效应，同时吸取其学术上的知识，在金融股市方面提供更加客观的分析。";
        NSMutableAttributedString *attStr = [self getAttributedStringWithString:textString lineSpace:5];
        [attStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, textString.length)];
        [attStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, textString.length)];
        introLbl.attributedText = attStr;
        [introLbl sizeToFit];
        introLbl.lineBreakMode = NSLineBreakByTruncatingTail;
        
        [headerView addSubview:introLbl];
        self.introLbl = introLbl;
        
        UIButton *moreTextBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREENWIDTH - 44 - 10, CGRectGetMaxY(introLbl.frame) + 10, 44, 22)];
        [moreTextBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [moreTextBtn setTitle:@"更多" forState:UIControlStateNormal];
        [moreTextBtn setTitle:@"收起" forState:UIControlStateSelected];
        [moreTextBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [moreTextBtn addTarget:self action:@selector(clickMoreTextBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        [headerView addSubview:moreTextBtn];
        self.moreTextBtn = moreTextBtn;
        self.headerView = headerView;
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = @"我是 cell";
    cell.textLabel.font = [UIFont systemFontOfSize:17];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"indexPath = %ld", indexPath.row);
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    //修改透明度  弹性
    CGFloat offsetY = scrollView.contentOffset.y + _headerView_height;
    UIColor * color = nil;
    if (_imageTableViewStyle == YAImageTableViewStyleOne) {
    
        color = [UIColor colorWithRed:0.16 green:0.17 blue:0.21 alpha:1.00];
        self.headerImageView.height = MAX(0, _headerView_height - offsetY);
        self.headerImageView.y = scrollView.contentOffset.y;
    } else if (_imageTableViewStyle == YAImageTableViewStyleTwo) {
    
        color = [UIColor colorWithRed:0.23 green:0.66 blue:0.87 alpha:1.00];
        if (offsetY <= 8) {
            self.tableView.bounces = NO;
        } else {
            self.tableView.bounces = YES;
        }
    }
    
    if (offsetY > _navbar_change_point) {
        CGFloat alpha = MIN(1, 1 - ((_navbar_change_point + 64 - offsetY) / 64));
        [self.navigationController.navigationBar ya_setBackgroundColor:[color colorWithAlphaComponent:alpha]];
        [self.titleLbl setTextColor:[UIColor colorWithWhite:1.0 alpha:alpha]];
    } else {
        [self.navigationController.navigationBar ya_setBackgroundColor:[color colorWithAlphaComponent:0]];
        [self.titleLbl setTextColor:[UIColor clearColor]];
    }
    
}

#pragma mark - 交互事件
- (void)clickMoreTextBtn: (UIButton *)btn {
    
    if (!btn.isSelected) {
        //        NSLog(@"展开");
        CGSize size = [self contentString:_introLbl.text resizeWithFont:[UIFont systemFontOfSize:15] lineSpace:5 adjustSize:CGSizeMake(SCREENWIDTH - 20, CGFLOAT_MAX)];
        self.introLbl.numberOfLines = 0;
        [UIView animateWithDuration:0.25 animations:^{
            self.introLbl.height = size.height;
            self.headerView.height += size.height - _introLbl_height;
            
        }];
        self.headerView.y = -self.headerView.height;
        self.tableView.contentInset = UIEdgeInsetsMake(self.headerView.height, 0, 0, 0);
        
    } else {
        //        NSLog(@"收起");
        self.introLbl.numberOfLines = 2;
        [UIView animateWithDuration:0.25 animations:^{
            self.introLbl.height = _introLbl_height;
            self.headerView.height = _headerView_height;
            
        }];
        self.headerView.y = -_headerView_height;
        self.tableView.contentInset = UIEdgeInsetsMake(self.headerView.height, 0, 0, 0);
    }
    self.moreTextBtn.y = CGRectGetMaxY(self.introLbl.frame) + 10;
    btn.selected = !btn.isSelected;
    [self scrollToTop];
}

#pragma mark - 懒加载
- (UITableView *)tableView {
    
    if (_tableView == nil) {
        
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        tableView.delegate = self;
        tableView.dataSource = self;
        
        _tableView = tableView;
        [self.view addSubview:_tableView];
        
        //注册cell
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
    }
    return _tableView;
}

#pragma mark - tools
/// 调整行间距
- (NSMutableAttributedString *)getAttributedStringWithString:(NSString *)string lineSpace:(CGFloat)lineSpace {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpace; // 调整行间距
    NSRange range = NSMakeRange(0, [string length]);
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
    return attributedString;
}

///获取字体的size
- (CGSize)contentString:(NSString *)str resizeWithFont:(UIFont *)font lineSpace:(CGFloat)lineSpace adjustSize:(CGSize)size {
    //注意：这里的字体要和控件的字体保持一致
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpace];
    attrs[NSParagraphStyleAttributeName] = paragraphStyle;
    //处理有换行时的宽，
    NSString *text = str;
    if (size.width > 10000) {
        NSArray *texts = [text componentsSeparatedByString:@"\r\n"];
        if (texts.count == 1) {
            texts = [text componentsSeparatedByString:@"\r"];
        }
        if (texts.count == 1) {
            texts = [text componentsSeparatedByString:@"\n"];
        }
        if (texts.count == 1) {
            texts = [text componentsSeparatedByString:@"\f"];
        }
        if (texts.count>0) {
            text = texts[0];
            for (int i=1; i<texts.count; i++) {
                NSString *str = [texts objectAtIndex:i];
                if (str.length>text.length) {
                    text = str;
                }
            }
        }
    }
    CGRect reFrame = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil];
    return reFrame.size;
}

///tableView 滚动到最顶部
- (void)scrollToTop {

    CGPoint off = self.tableView.contentOffset;
    off.y = 0 - self.tableView.contentInset.top;
    [self.tableView setContentOffset:off animated:YES];
}


@end
