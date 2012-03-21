//
//  CurvePointView.m
//  bezierdrawing
//
//  Created by Søren Toft on 3/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "StartPointView.h"

@implementation StartPointView

- (id)initWithPosition:(CGPoint)position pointNumber:(NSInteger)number {
    self = [super initWithFrame:CGRectMake(0, 0, 20, 20)];
    self.center = position;
    if (self) {
        self.backgroundColor = [UIColor blueColor]; 
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 10, 20)];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:9];
        label.textColor = [UIColor whiteColor];
        label.text = [NSString stringWithFormat:@"%d", number];
        [self addSubview:label];
    }
    return self;
}

@end
