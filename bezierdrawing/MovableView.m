//
//  MovableView.m
//  bezierdrawing
//
//  Created by Søren Toft on 3/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MovableView.h"

@implementation MovableView {
    NSInteger _touchOfCenterX;
    NSInteger _touchOfCenterY;
}

@synthesize delegate = _delegate;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self.superview];  
    _touchOfCenterX = (NSInteger) (self.center.x - location.x);
    _touchOfCenterY = (NSInteger) (self.center.y - location.y);
}


- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event {
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self.superview];
    CGFloat xLocation = location.x + _touchOfCenterX;
    CGFloat yLocation = location.y + _touchOfCenterY;
    
    
    self.center = CGPointMake(xLocation, yLocation);
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [_delegate touchEnded];
}


@end
