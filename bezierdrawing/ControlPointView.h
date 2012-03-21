//
//  CurveControlPointView.h
//  bezierdrawing
//
//  Created by Søren Toft on 3/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MovableView.h"

@interface ControlPointView : MovableView

- (id)initWithPosition:(CGPoint)position pointNumber:(NSInteger)number controlPointNumber:(NSInteger)cpNumber;

@end
