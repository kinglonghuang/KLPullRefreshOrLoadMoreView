//
//  KLPullRefreshOrLoadMoreView.m
//  TestIDFPullView
//
//  Created by kinglonghuang on 12/11/13.
//  Copyright (c) 2013 LongVisionMedia. All rights reserved.
//

#import <CoreText/CoreText.h>
#import "KLPullRefreshOrLoadMoreView.h"

#define FLIP_ANIMATION_DURATION             0.18f

@implementation KLPullRefreshOrLoadMoreInfo : NSObject 

@end

@interface KLPullRefreshOrLoadMoreView()

@property (nonatomic, assign) KLPullRefreshOrLoadMoreViewState     pullRefreshOrLoadMoreState;

@property (nonatomic, strong) UILabel                               * desLabel;

@property (nonatomic, strong) CALayer                               * imgViewLayer;

@property (nonatomic, strong) UIActivityIndicatorView               * activityView;

@end

@implementation KLPullRefreshOrLoadMoreView

#pragma mark - Public

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (![self isPullEnabled]) {
        return;
    }
    
    if (self.pullRefreshOrLoadMoreState != KLPullRefreshOrLoadMoreViewStateLoading) {
		if (self.pullRefreshOrLoadMoreState == KLPullRefreshOrLoadMoreViewStatePulling && ![self shouldTiggleRefreshOrLoadMoreForScrollView:scrollView]) {
			[self setPullRefreshOrLoadMoreState:KLPullRefreshOrLoadMoreViewStateNormal];
		} else if (self.pullRefreshOrLoadMoreState == KLPullRefreshOrLoadMoreViewStateNormal && [self shouldTiggleRefreshOrLoadMoreForScrollView:scrollView]) {
			[self setPullRefreshOrLoadMoreState:KLPullRefreshOrLoadMoreViewStatePulling];
		}
	}
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView {
    if (![self isPullEnabled]) {
        return;
    }
    
    if (self.pullRefreshOrLoadMoreState == KLPullRefreshOrLoadMoreViewStateLoading) {
        return;
    }
    
	if ([self shouldTiggleRefreshOrLoadMoreForScrollView:scrollView]) {
		
        [self askForRefreshOrLoadMore];
		
		[self setPullRefreshOrLoadMoreState:KLPullRefreshOrLoadMoreViewStateLoading];
        
        [UIView animateWithDuration:0.2 animations:^{
            [self applyOffsetOnScrollView:scrollView withOffset:self.frame.size.height];
        }];
	}
}

- (void)scrollViewDidFinishLoading:(UIScrollView *)scrollView {
    if (![self isPullEnabled]) {
        return;
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        scrollView.contentInset = UIEdgeInsetsZero;
    }completion:^(BOOL finished) {
        if (finished) {
            [self setPullRefreshOrLoadMoreState:KLPullRefreshOrLoadMoreViewStateNormal];
        }
    }];
}

#pragma mark - Private

- (NSString *)pullingText {
    NSString * pullingText = NSLocalizedString(@"Pull to load more", @"Des for pull");
    if ([self.info.pullingText length]) {
        pullingText = [self.info pullingText];
    }
    return pullingText;
}

- (NSString *)releaseText {
    NSString * releaseText = NSLocalizedString(@"Release to load more", @"Des for release");
    if ([self.info.releaseText length]) {
        releaseText = [self.info releaseText];
    }
    return releaseText;
}

- (NSString *)loadingText {
    NSString * loadingText = NSLocalizedString(@"Loading", @"Des for Loading");
    if ([self.info.loadingText length]) {
        loadingText = [self.info loadingText];
    }
    return loadingText;
}

- (NSString *)textForState:(KLPullRefreshOrLoadMoreViewState)state {
    switch (state) {
        case KLPullRefreshOrLoadMoreViewStateLoading: {
            return [self loadingText];
        }
        case KLPullRefreshOrLoadMoreViewStateNormal: {
            return [self pullingText];
        }
        case KLPullRefreshOrLoadMoreViewStatePulling: {
            return [self releaseText];
        }
        default: {
            return [self pullingText];
        }
    }
}

- (BOOL)isPullEnabled {
    return self.info ? self.info.pullEnabled : YES;
}

- (void)askForRefreshOrLoadMore {
    if (self.type == KLPullRefreshOrLoadMoreViewTypeRefresh) {
        if ([self.delegate respondsToSelector:@selector(pullRefreshOrLoadMoreViewAskForRefresh:)]) {
            [self.delegate pullRefreshOrLoadMoreViewAskForRefresh:self];
        }
    }else {
        if ([self.delegate respondsToSelector:@selector(pullRefreshOrLoadMoreViewAskForLoadMore:)]) {
            [self.delegate pullRefreshOrLoadMoreViewAskForLoadMore:self];
        }
    }
}

- (void)applyOffsetOnScrollView:(UIScrollView *)scView withOffset:(CGFloat)offset {
    switch (self.type) {
        case KLPullRefreshOrLoadMoreViewTypeLoadMore: {
            [scView setContentInset:UIEdgeInsetsMake(0, 0, offset, 0)];
            break;
        }
        case KLPullRefreshOrLoadMoreViewTypeRefresh: {
            [scView setContentInset:UIEdgeInsetsMake(offset, 0, 0, 0)];
            break;
        }
        default:
            break;
    }
}

- (BOOL)shouldTiggleRefreshOrLoadMoreForScrollView:(UIScrollView *)scrollView {
    BOOL shouldTiggle = NO;
    
    switch (self.type) {
        case KLPullRefreshOrLoadMoreViewTypeLoadMore: {
            if (scrollView.contentOffset.y+scrollView.bounds.size.height >= scrollView.contentSize.height+self.frame.size.height) {
                shouldTiggle = YES;
            }
            break;
        }
        case KLPullRefreshOrLoadMoreViewTypeRefresh: {
            if (scrollView.contentOffset.y < -1*self.frame.size.height) {
                shouldTiggle = YES;
            }
            break;
        }
        default:
            break;
    }
    return shouldTiggle;
}

- (void)updateLayoutForArrayImgViewWithAnimation:(BOOL)withAnimation state:(KLPullRefreshOrLoadMoreViewState)state {
    CATransform3D transform = CATransform3DIdentity;
    switch (state) {
        case KLPullRefreshOrLoadMoreViewStateNormal: {
            if (self.type == KLPullRefreshOrLoadMoreViewTypeLoadMore) {
                transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
            }
            break;
        }
        case KLPullRefreshOrLoadMoreViewStatePulling: {
            if (self.type == KLPullRefreshOrLoadMoreViewTypeRefresh) {
                transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
            }
            break;
        }
        default:
            break;
    }
    if (withAnimation) {
        [CATransaction begin];
        [CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
        [self.imgViewLayer setTransform:transform];
        [CATransaction commit];
    }else {
        [self.imgViewLayer setTransform:transform];
    }
}

- (void)showOrHideUIWithState:(KLPullRefreshOrLoadMoreViewState)state {
    switch (state) {
        case KLPullRefreshOrLoadMoreViewStatePulling:
        case KLPullRefreshOrLoadMoreViewStateNormal:{
            [self.imgViewLayer setHidden:NO];
            [self.activityView setAlpha:0.0];
            break;
        }
        case KLPullRefreshOrLoadMoreViewStateLoading: {
            [self.imgViewLayer setHidden:YES];
            [self.activityView setAlpha:1.0];
            break;
        }
        default:
            break;
    }
}

- (void)adjustUIWithDesText:(NSString *)desText state:(KLPullRefreshOrLoadMoreViewState)state {
    [self.desLabel setText:desText];
    CGSize textSize = CGSizeZero;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
        CTFontRef fontRef = CTFontCreateWithName((CFStringRef)self.desLabel.font.fontName,self.desLabel.font.pointSize,NULL);
        textSize = [desText sizeWithAttributes:[NSDictionary dictionaryWithObject:(__bridge id)fontRef forKey:(NSString *)kCTFontAttributeName]];
#endif
    }else {
#if __IPHONE_OS_VERSION_MAX_ALLOWED < 70000
        textSize = [desText sizeWithFont:self.desLabel.font];
#endif
    }
    
    CGFloat imgOrActivityWidth = (state == KLPullRefreshOrLoadMoreViewStateLoading ? self.activityView.frame.size.width : self.imgViewLayer.frame.size.width);
    CGFloat sumWidthForLeftUICompent = imgOrActivityWidth + 10; //10 for margin
    CGRect labelFrame = self.desLabel.frame;
    labelFrame.size.width = textSize.width + 10; //10 for Margin
    labelFrame.origin.x = (self.frame.size.width - (textSize.width+sumWidthForLeftUICompent))/2.0 + sumWidthForLeftUICompent;
    [self.desLabel setFrame:labelFrame];
    
    CGRect arrowFrame = self.imgViewLayer.frame;
    arrowFrame.origin.x = labelFrame.origin.x - sumWidthForLeftUICompent;
    [self.imgViewLayer setFrame:arrowFrame];
    
    CGRect activityFrame = self.activityView.frame;
    activityFrame.origin.x = labelFrame.origin.x - sumWidthForLeftUICompent;
    [self.activityView setFrame:activityFrame];
}

- (void)removeAllSubviews {
    [self.desLabel removeFromSuperview];
    [self.imgViewLayer removeFromSuperlayer];
    [self.activityView removeFromSuperview];
    [self.customView removeFromSuperview];
}

- (void)layoutWithCustomView {
    CGRect frame = CGRectMake((self.frame.size.width - self.customView.frame.size.width)/2.0, (self.frame.size.height - self.customView.frame.size.height)/2.0, self.customView.frame.size.width, self.customView.frame.size.height);
    [self.customView setFrame:frame];
    [self.customView setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin];
    [self addSubview:self.customView];
    
    //[self setPullRefreshOrLoadMoreState:KLPullRefreshOrLoadMoreViewStateNormal];
}

- (void)layoutWithLoadMoreInfo {
    if (![self isPullEnabled]) {
        //If pull is not enabled, remove all subview and return
        [self removeAllSubviews];
        return;
    }
    
    UIColor * bgColor = self.info.backgroundColor ? self.info.backgroundColor : [UIColor clearColor];
    [self setBackgroundColor:bgColor];
    
    UIImage * img = self.info.arrowImage ? self.info.arrowImage : [UIImage imageNamed:@"arrow"];
    self.imgViewLayer = [CALayer layer];
    [self.imgViewLayer setContentsGravity:kCAGravityResizeAspect];
    [self.imgViewLayer setContents:(id)[img CGImage]];
    CGSize imgSize = [img size];
    [self.imgViewLayer setFrame:CGRectMake(0, (self.frame.size.height-imgSize.height)/2.0, imgSize.width, imgSize.height)];
    [self.layer addSublayer:self.imgViewLayer];
    
    UIActivityIndicatorViewStyle style = self.info ? self.info.activityStyle : UIActivityIndicatorViewStyleGray;
    self.activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:style];
    CGSize activitySize = self.activityView.frame.size;
    [self.activityView setFrame:CGRectMake(0, (self.frame.size.height-activitySize.height)/2.0, activitySize.width, activitySize.height)];
    [self addSubview:self.activityView];
    
    self.desLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width/2.0+10, self.frame.size.height)];
    UIColor * textColor = self.info.textColor ? self.info.textColor : [UIColor grayColor];
    UIFont * textFont = self.info.textFont ? self.info.textFont : [UIFont systemFontOfSize:14];
    [self.desLabel setTextColor:textColor];
    [self.desLabel setFont:textFont];
    [self.desLabel setBackgroundColor:[UIColor clearColor]];
    [self addSubview:self.desLabel];
    
    [self setPullRefreshOrLoadMoreState:KLPullRefreshOrLoadMoreViewStateNormal];
}

- (void)updateUI {
    [self removeAllSubviews];
    
    if (self.customView) {
        [self layoutWithCustomView];
    }else {
        [self layoutWithLoadMoreInfo];
    }
}

#pragma mark - LifeCycle

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setInfo:nil];
    }
    return self;
}

- (void)setInfo:(KLPullRefreshOrLoadMoreInfo *)info {
    if (_info != info) {
        _info = info;
        [self updateUI];
    }
}

- (void)setCustomView:(UIView *)customView {
    if (_customView != customView) {
        [_customView removeFromSuperview];
        _customView = customView;
        [self updateUI];
    }
}

- (void)setType:(KLPullRefreshOrLoadMoreViewType)type {
    if (_type != type) {
        _type = type;
        [self updateUI];
    }
}

- (void)setPullRefreshOrLoadMoreState:(KLPullRefreshOrLoadMoreViewState)pullRefreshOrLoadMoreState {
    if (self.customView) {
        if ([self.delegate respondsToSelector:@selector(pullRefreshOrLoadMoreView:customViewShouldUpdateForState:)]) {
            [self.delegate pullRefreshOrLoadMoreView:self customViewShouldUpdateForState:pullRefreshOrLoadMoreState];
        }
    }else {
        NSString * text = [self textForState:pullRefreshOrLoadMoreState];
        [self showOrHideUIWithState:pullRefreshOrLoadMoreState];
        [self adjustUIWithDesText:text state:pullRefreshOrLoadMoreState];
        switch (pullRefreshOrLoadMoreState) {
            case KLPullRefreshOrLoadMoreViewStateLoading: {
                [self.activityView startAnimating];
                break;
            }
            case KLPullRefreshOrLoadMoreViewStateNormal:
            case KLPullRefreshOrLoadMoreViewStatePulling: {
                [self updateLayoutForArrayImgViewWithAnimation:YES state:pullRefreshOrLoadMoreState];
            }
            default:
                break;
        }
    }
    
    _pullRefreshOrLoadMoreState = pullRefreshOrLoadMoreState;
}

@end
