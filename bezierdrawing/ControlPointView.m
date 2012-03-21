//
//  CurveControlPointView.m
//  bezierdrawing
//
//  Created by Søren Toft on 3/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ControlPointView.h"

@implementation ControlPointView

- (id)initWithPosition:(CGPoint)position pointNumber:(NSInteger)number controlPointNumber:(NSInteger)cpNumber {
    self = [super initWithFrame:CGRectMake(0, 0, 20, 20)];
    self.center = position;
    if (self) {
        self.backgroundColor = [UIColor redColor]; 
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 15, 20)];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:9];
        label.text = [NSString stringWithFormat:@"%d.%d", number, cpNumber];
        [self addSubview:label];
    }
    return self;
}

@end
