KLPullRefreshOrLoadMoreView
===========================

Pull refresh or load more view for iOS <br>
支持经典的iOS上拉／下拉刷新机制，支持界面和行为自定义

  self.pullRefreshView = [[KLPullRefreshOrLoadMoreView alloc] initWithFrame:CGRectMake(0, -65,   self.tableView.frame.size.width, 65)];
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
