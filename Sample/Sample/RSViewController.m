//
//  RSViewController.m
//  Sample
//
//  Created by R0CKSTAR on 7/1/13.
//  Copyright (c) 2013 P.D.Q. All rights reserved.
//

#import "RSViewController.h"
#import "RSLoadingIndicator.h"

@interface RSViewController () <RSLoadingIndicatorDelegate> {
    RSLoadingIndicator *indicator;
    NSTimer *ticker;
    NSTimer *stopTimer;
}

@end

@implementation RSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    indicator = [[[RSLoadingIndicator alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)] autorelease];
    indicator.delegate = self;
    [self.view addSubview:indicator];
    
    ticker = [[NSTimer scheduledTimerWithTimeInterval:1.0f / 33.0f target:self selector:@selector(tick) userInfo:nil repeats:YES] retain];
}

- (void)tick {
    [indicator didScroll:0.5f];
}

- (void)stop {
    [indicator stopLoading];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - RSLoadingIndicatorDelegate

- (void)startLoading {
    stopTimer = [[NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(stop) userInfo:nil repeats:NO] retain];
}

- (void)stopLoading {
    [ticker invalidate];
    [ticker release];
    ticker = nil;
    
    [stopTimer invalidate];
    [stopTimer release];
    stopTimer = nil;
}

@end
