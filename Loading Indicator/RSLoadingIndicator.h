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
    float radius; // Circle radius
    CGPoint center; // Circle center
    float arrowEdgeLength; // Arrow is equilateral triangle
    float radianceDegree; // How many degree between two radiance
    float radianceOffset; // Offset from circle
    float radianceMinLength; // Min length of the radiance
    float radianceMaxLength; // Max length of the radiance
    float sprintMax; // Radiance act like a sprint and this value controls the threshold
    float rotationSpeed; // Rotation spped
}

@property (assign, nonatomic) id<RSLoadingIndicatorDelegate> delegate;

- (void)didScroll:(float)offset;

- (void)stopLoading;

@end
