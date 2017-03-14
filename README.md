# YAHeadImageTableView

TableView滚动时导航栏渐变,顶部图片拉伸,文字展开与收缩,看这里就行了!

首先说下导航栏渐变的实现原理

为UINavigationBar添加一个分类,提供一个设置其背景颜色的方法,注意的是在这个方法中必须设置 [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault]
(PS:这个方法重写了系统默认的导航栏背景图);然后覆盖一张等大的view,用来从外界动态设置带透明度的颜色,从而实现表格滚动时,导航栏的颜色渐变.是不是很简单呢?看代码:

- (void)ya_setBackgroundColor:(UIColor *)backgroundColor {
    if (!self.overlay) {
    [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.overlay = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) + 20)];
    self.overlay.userInteractionEnabled = NO;
    self.overlay.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [[self.subviews firstObject] insertSubview:self.overlay atIndex:0];
}
self.overlay.backgroundColor = backgroundColor;
}
再说下拉时,顶部图片跟着变高并保持比例的实现

这里主要是利用系统已提供好的UIImageView 的contentMode属性,设置成UIViewContentModeScaleAspectFill即可.细节方面:整个顶部其实添加到了tableview上, tableview设置内边距属性contentInset;如果要显示垂直方向的指示条,则需同步设置self.tableView.scrollIndicatorInsets = self.tableView.contentInset(美观而已).控制弹性只能从tableView.bounces上下功夫.最后一切动态变化,在scrollViewDidScroll:代理方法中实现,核心代码如下:

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
最后说下UILabel文字的展开与收起

只需要更改frame,刷新视图即可.这个就必须说道设置行距和获取一段文字在UILabel中size.工具方法如下:
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
这两个方法可以单独抽取成工具类,随时拿来直接使用,项目中没有进行抽离,有需要的同学可以自己动手一下.
