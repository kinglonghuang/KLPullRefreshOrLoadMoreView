//
//  KLPullRefreshOrLoadMoreView.h
//  TestIDFPullView
//
//  Created by kinglonghuang on 12/11/13.
//  Copyright (c) 2013 LongVisionMedia. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, KLPullRefreshOrLoadMoreViewState) {
	KLPullRefreshOrLoadMoreViewStateNormal = 0,
	KLPullRefreshOrLoadMoreViewStatePulling,
	KLPullRefreshOrLoadMoreViewStateLoading,
};

typedef NS_ENUM(NSInteger, KLPullRefreshOrLoadMoreViewType) {
    KLPullRefreshOrLoadMoreViewTypeRefresh = 0,//Header
    KLPullRefreshOrLoadMoreViewTypeLoadMore    //Footer
};

@class KLPullRefreshOrLoadMoreView;

@protocol KLPullRefreshOrLoadMoreViewDelegate <NSObject>

@required

- (void)pullRefreshOrLoadMoreViewAskForRefresh:(KLPullRefreshOrLoadMoreView *)refreshOrLoadMoreView;

- (void)pullRefreshOrLoadMoreViewAskForLoadMore:(KLPullRefreshOrLoadMoreView *)refreshOrLoadMoreView;

@optional

- (void)pullRefreshOrLoadMoreView:(KLPullRefreshOrLoadMoreView *)refreshOrLoadMoreView customViewShouldUpdateForState:(KLPullRefreshOrLoadMoreViewState)state;

@end

@interface KLPullRefreshOrLoadMoreInfo : NSObject

@property (nonatomic, assign) BOOL                              pullEnabled;

@property (nonatomic, assign) UIActivityIndicatorViewStyle      activityStyle;

@property (nonatomic, strong) UIColor                           * backgroundColor;

@property (nonatomic, strong) UIImage                           * arrowImage;

@property (nonatomic, strong) NSString                          * pullingText;

@property (nonatomic, strong) NSString                          * releaseText;

@property (nonatomic, strong) NSString                          * loadingText;

@property (nonatomic, strong) UIColor                           * textColor;

@property (nonatomic, strong) UIFont                            * textFont;

@end


@interface KLPullRefreshOrLoadMoreView : UIView

@property (nonatomic, weak) id <KLPullRefreshOrLoadMoreViewDelegate>    delegate;

@property (nonatomic, assign) KLPullRefreshOrLoadMoreViewType           type;

@property (nonatomic, strong) KLPullRefreshOrLoadMoreInfo               * info;

@property (nonatomic, strong) UIView                                    * customView;

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView;

- (void)scrollViewDidFinishLoading:(UIScrollView *)scrollView;

@end
