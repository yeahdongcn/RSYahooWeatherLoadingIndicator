//
//  RSLoadingIndicator.h
//  Sample
//
//  Created by R0CKSTAR on 7/1/13.
//  Copyright (c) 2013 P.D.Q. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RSLoadingIndicatorDelegate <NSObject>

@optional

- (void)startLoading;

- (void)stopLoading;

@end

@interface RSLoadingIndicator : UIView {
    float radius;
    CGPoint center;
    float arrowEdgeLength;
    float radianceDegree;
    float radianceOffset;
    float radianceMinLength;
    float radianceMaxLength;
    float sprintMax;
    float rotationSpeed;
}

@property (assign, nonatomic) id<RSLoadingIndicatorDelegate> delegate;

- (void)didScroll:(float)offset;

- (void)stopLoading;

@end
