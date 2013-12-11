//
//  ViewController.m
//  KLPullRefreshOrLoadMoreViewDemo
//
//  Created by kinglonghuang on 12/11/13.
//  Copyright (c) 2013 KLStudio. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) NSMutableArray                * dateArray;

@property (nonatomic, strong) KLPullRefreshOrLoadMoreView  * pullRefreshView;

@property (nonatomic, strong) KLPullRefreshOrLoadMoreView  * pullLoadMoreView;

@end

@implementation ViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.dateArray = [NSMutableArray arrayWithCapacity:0];
    for (NSInteger index = 0; index < 3; index++) {
        [self.dateArray addObject:[NSDate date]];
    }
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView reloadData];
    
    //Demo Code
    self.pullRefreshView = [[KLPullRefreshOrLoadMoreView alloc] initWithFrame:CGRectMake(0, -65, self.tableView.frame.size.width, 65)];
    [self.pullRefreshView setType:KLPullRefreshOrLoadMoreViewTypeRefresh];
    [self.pullRefreshView setDelegate:self];
    [self.view addSubview:self.pullRefreshView];
    
    //Custom the default layout if needed
    KLPullRefreshOrLoadMoreInfo * info = [[KLPullRefreshOrLoadMoreInfo alloc] init];
    [info setPullEnabled:YES];
    [info setActivityStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [info setBackgroundColor:[UIColor lightGrayColor]];
    [info setArrowImage:[UIImage imageNamed:@"arrow"]];
    [info setPullingText:NSLocalizedString(@"下拉刷新", @"Des for Refresh")];
    [info setLoadingText:NSLocalizedString(@"正在加载", @"Des for Loading")];
    [info setReleaseText:NSLocalizedString(@"释放刷新", @"Des for Release")];
    [info setTextColor:[UIColor purpleColor]];
    [info setTextFont:[UIFont systemFontOfSize:16]];
    [self.pullRefreshView setInfo:info];
    
    //PullLoadMore using custom view. you should implement the customViewAskForUpdateUIWithState method
    self.pullLoadMoreView = [[KLPullRefreshOrLoadMoreView alloc] initWithFrame:CGRectMake(0, self.tableView.contentSize.height, self.tableView.frame.size.width, 65)];
    [self.pullLoadMoreView setType:KLPullRefreshOrLoadMoreViewTypeLoadMore];
    [self.pullLoadMoreView setDelegate:self];
    UIView * customViewForPullLoadMoreView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    [customViewForPullLoadMoreView setBackgroundColor:[UIColor yellowColor]];
    [self.pullLoadMoreView setCustomView:customViewForPullLoadMoreView];
    [self.view addSubview:self.pullLoadMoreView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private

- (void)loadFinished {
    [self.pullRefreshView scrollViewDidFinishLoading:self.tableView];
    [self.pullLoadMoreView scrollViewDidFinishLoading:self.tableView];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.pullRefreshView scrollViewDidScroll:scrollView];
    [self.pullLoadMoreView scrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self.pullRefreshView scrollViewDidEndDragging:scrollView];
    [self.pullLoadMoreView scrollViewDidEndDragging:scrollView];
}


#pragma mark - IDFPullRefreshOrLoadMoreDelegate

- (void)pullRefreshOrLoadMoreViewAskForRefresh:(KLPullRefreshOrLoadMoreView *)refreshOrLoadMoreView {
    [self performSelector:@selector(loadFinished) withObject:nil afterDelay:3.0];
}


- (void)pullRefreshOrLoadMoreViewAskForLoadMore:(KLPullRefreshOrLoadMoreView *)refreshOrLoadMoreView {\
    [self performSelector:@selector(loadFinished) withObject:nil afterDelay:3.0];
}

- (void)pullRefreshOrLoadMoreView:(KLPullRefreshOrLoadMoreView *)refreshOrLoadMoreView customViewShouldUpdateForState:(KLPullRefreshOrLoadMoreViewState)state {
    switch (state) {
        case KLPullRefreshOrLoadMoreViewStateLoading: {
            [refreshOrLoadMoreView.customView setBackgroundColor:[UIColor greenColor]];
            break;
        }
        case KLPullRefreshOrLoadMoreViewStateNormal: {
            [refreshOrLoadMoreView.customView setBackgroundColor:[UIColor yellowColor]];
            break;
        }
        case KLPullRefreshOrLoadMoreViewStatePulling: {
            [refreshOrLoadMoreView.customView setBackgroundColor:[UIColor redColor]];
            break;
        }
            
        default:
            break;
    }
}

#pragma mark - UITableView Delegate & DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dateArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    NSDate *object = self.dateArray[indexPath.row];
    cell.textLabel.text = [object description];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


@end
