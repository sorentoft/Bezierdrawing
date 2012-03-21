//
//  CurveView.h
//  bezierdrawing
//
//  Created by Søren Toft on 3/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "StartPointView.h"
#import "ControlPointView.h"

@protocol MyBezierPathDelegate <NSObject>
- (void)pathChanged;
@end 


@interface MyBezierPath : NSObject<MovableViewDelegate>

- (id)initWithViewParent:(UIView *)parent at:(CGPoint)position;

@property (readonly) StartPointView *startPoint;
@property (readonly) ControlPointView *controlPoint1;
@property (readonly) ControlPointView *controlPoint2;

@property (weak) id<MyBezierPathDelegate> delegate;

@end
