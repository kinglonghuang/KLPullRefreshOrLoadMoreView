//
//  IDFPullRefreshOrLoadMoreView.h
//  TestIDFPullView
//
//  Created by kinglonghuang on 12/11/13.
//  Copyright (c) 2013 LongVisionMedia. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, IDFPullRefreshOrLoadMoreViewState) {
	IDFPullRefreshOrLoadMoreViewStateNormal = 0,
	IDFPullRefreshOrLoadMoreViewStatePulling,
	IDFPullRefreshOrLoadMoreViewStateLoading,
};

typedef NS_ENUM(NSInteger, IDFPullRefreshOrLoadMoreViewType) {
    IDFPullRefreshOrLoadMoreViewTypeRefresh = 0,//Header
    IDFPullRefreshOrLoadMoreViewTypeLoadMore    //Footer
};

@class IDFPullRefreshOrLoadMoreView;

@protocol IDFPullRefreshOrLoadMoreViewDelegate <NSObject>

@required

- (void)pullRefreshOrLoadMoreViewAskForRefresh:(IDFPullRefreshOrLoadMoreView *)refreshOrLoadMoreView;

- (void)pullRefreshOrLoadMoreViewAskForLoadMore:(IDFPullRefreshOrLoadMoreView *)refreshOrLoadMoreView;

@optional

- (void)pullRefreshOrLoadMoreView:(IDFPullRefreshOrLoadMoreView *)refreshOrLoadMoreView customViewShouldUpdateForState:(IDFPullRefreshOrLoadMoreViewState)state;

@end

@interface IDFPullRefreshOrLoadMoreInfo : NSObject

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


@interface IDFPullRefreshOrLoadMoreView : UIView

@property (nonatomic, weak) id <IDFPullRefreshOrLoadMoreViewDelegate>   delegate;

@property (nonatomic, assign) IDFPullRefreshOrLoadMoreViewType          type;

@property (nonatomic, strong) IDFPullRefreshOrLoadMoreInfo              * info;

@property (nonatomic, strong) UIView                                    * customView;

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView;

- (void)scrollViewDidFinishLoading:(UIScrollView *)scrollView;

@end
