//
//  RSLoadingIndicator.m
//  Sample
//
//  Created by R0CKSTAR on 7/1/13.
//  Copyright (c) 2013 P.D.Q. All rights reserved.
//

#import "RSLoadingIndicator.h"
#import <QuartzCore/QuartzCore.h>

@interface RSLoadingIndicator () {
    float _startAngle; // Start angle of the cycle, never changed
    float _endAngle; // End angle of the cycle
    float _startY; // Line start y
    float _spring; // Current spring
    int _springDirection; // Sprint direction +/-
    int _counter; // Counter, used for rotation
}

@end

@implementation RSLoadingIndicator
float Radian2Degree(float radian) {
    return ((radian / M_PI) * 180.0f);
}

float Degree2Radian(float degree) {
    return ((degree / 180.0f) * M_PI);
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor grayColor];
        
        center = self.center;
        radius = 15;
        arrowEdgeLength = 10;
        radianceDegree = 30;
        radianceOffset = 5;
        radianceMinLength = 5;
        radianceMaxLength = 15;
        sprintMax = 1;
        rotationSpeed = 1.0f;
        
        _startAngle = -90;
        _endAngle = -90;
        _startY = -(2.0f * M_PI * radius);
        _spring = 0;
        _springDirection = 0;
    }
    
    return self;
}

- (void)didScroll:(float)offset {
    if (_startY == 0) {
        if (_delegate && [_delegate respondsToSelector:@selector(startLoading)]) {
            [_delegate startLoading];
        }
        
        _startY = 1;
    } else if (_startY == 1) {
        if (_counter == (NSUIntegerMax - 1)) {
            _counter = 0;
        }
        
        _counter++;
        [self setNeedsDisplay];
    } else {
        _startY += offset;
        float deltaAngle = Radian2Degree(offset / radius);
        _endAngle += deltaAngle;
        
        if (roundf(_startY) >= 0) {
            _endAngle = 270;
            _startY = 0;
        }
        
        [self setNeedsDisplay];
    }
}

- (void)stopLoading {
    _endAngle = -90;
    _startY = -(2.0f * M_PI * radius);
    [self setNeedsDisplay];
    
    if (_delegate && [_delegate respondsToSelector:@selector(stopLoading)]) {
        [_delegate stopLoading];
    }
}

- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(ctx);
    
    CGContextSetShouldAntialias(ctx, YES);
    CGContextSetAllowsAntialiasing(ctx, YES);
    
    CGContextBeginPath(ctx);
    
    CGContextSetStrokeColorWithColor(ctx, [UIColor whiteColor].CGColor);
    CGContextSetLineWidth(ctx, 2);
    CGContextMoveToPoint(ctx, center.x, center.y - radius + _startY);
    CGContextAddLineToPoint(ctx, center.x, center.y - radius);
    CGContextAddArc(ctx, center.x, center.y, radius, Degree2Radian(_startAngle), Degree2Radian(_endAngle), NO);
    CGPoint point = CGContextGetPathCurrentPoint(ctx);
    CGContextDrawPath(ctx, kCGPathStroke);
    
    if (_startY < 0) {
        float degree = 0;
        
        if ((point.x < center.x && point.y > center.y) || (point.x > center.x && point.y > center.y)) {
            degree = -90;
        } else {
            degree = 90;
        }
        
        float k = -(point.x - center.x) / (point.y - center.y);
        CGContextTranslateCTM(ctx, point.x, point.y);
        CGContextRotateCTM(ctx, Degree2Radian(degree) + atan(k));
        
        CGContextMoveToPoint(ctx, 0, -1.0f / sqrtf(3) * arrowEdgeLength);
        CGContextAddLineToPoint(ctx, -arrowEdgeLength / 2.0f, sqrtf(3) / 6.0f * arrowEdgeLength);
        CGContextAddLineToPoint(ctx, arrowEdgeLength / 2.0f, sqrtf(3) / 6.0f * arrowEdgeLength);
        CGContextClosePath(ctx);
        CGContextSetFillColorWithColor(ctx, [UIColor whiteColor].CGColor);
        CGContextFillPath(ctx);
    } else {
        CGContextTranslateCTM(ctx, center.x, center.y);
        
        for (int i = 0; i < (Radian2Degree(M_PI * 2) / radianceDegree); i++) {
            if (i > 0) {
                CGContextRotateCTM(ctx, Degree2Radian(radianceDegree));
            } else {
                CGContextRotateCTM(ctx, Degree2Radian(_counter * rotationSpeed));
            }
            
            if (_springDirection == 0) {
                _spring += 0.005f;
                
                if (_spring >= sprintMax) {
                    _springDirection = 1;
                }
            }
            
            if (_springDirection == 1) {
                _spring -= 0.005f;
                
                if (_spring <= 0) {
                    _springDirection = 0;
                }
            }
            
            if (i % 2 == 1) {
                CGContextMoveToPoint(ctx, 0, -radius - radianceOffset - radianceMinLength + _spring);
                CGContextAddLineToPoint(ctx, 0, -radius - radianceOffset - radianceMaxLength - _spring);
            } else {
                CGContextMoveToPoint(ctx, 0, -radius - radianceOffset - radianceMinLength - _spring);
                CGContextAddLineToPoint(ctx, 0, -radius - radianceOffset - radianceMaxLength + _spring);
            }
        }
        
        CGContextDrawPath(ctx, kCGPathStroke);
    }
    
    CGContextRestoreGState(ctx);
}

@end
