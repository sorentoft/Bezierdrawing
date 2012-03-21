//
//  CurveView.m
//  bezierdrawing
//
//  Created by Søren Toft on 3/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MyBezierPath.h"

@implementation MyBezierPath

@synthesize startPoint = _startPoint;
@synthesize controlPoint1 = _controlPoint1;
@synthesize controlPoint2 = _controlPoint2;
@synthesize delegate = _delegate;


static NSInteger pathCount = 1;

- (id)initWithViewParent:(UIView *)parent at:(CGPoint)position  {
    self = [super init];
    if (self) {
        _startPoint = [[StartPointView alloc] initWithPosition:position pointNumber:pathCount];
        _startPoint.delegate = self;
        
        _controlPoint1 = [[ControlPointView alloc] 
                          initWithPosition:CGPointMake(position.x, position.y - 20) pointNumber:pathCount controlPointNumber:1];
        _controlPoint1.delegate = self;
        
        _controlPoint2 = [[ControlPointView alloc] 
                          initWithPosition:CGPointMake(position.x, position.y + 20) pointNumber:pathCount controlPointNumber:2];
        _controlPoint2.delegate = self;
        
        pathCount++;
        
        [parent addSubview:_startPoint];
        [parent addSubview:_controlPoint1];
        [parent addSubview:_controlPoint2];        
    }
    return self;
}

# pragma mark - MovableViewDeleage
- (void)touchEnded {
    [_delegate pathChanged];
}

@end
