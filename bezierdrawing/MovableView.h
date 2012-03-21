//
//  MovableView.h
//  bezierdrawing
//
//  Created by Søren Toft on 3/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MovableViewDelegate
- (void)touchEnded;
@end


@interface MovableView : UIView

@property (weak) id<MovableViewDelegate> delegate;

@end
