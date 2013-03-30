//
//  ViewController.m
//  bezierdrawing
//
//  Created by Søren Toft on 3/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>

#import "ViewController.h"

#import "StartPointView.h"
#import "MyBezierPath.h"

//width is set to "height" as we are in landscape mode
#define SCREEN_WIDTH [[UIScreen mainScreen] applicationFrame].size.height 
#define SCREEN_HEIGHT [[UIScreen mainScreen] applicationFrame].size.width


@implementation ViewController {
    
    UIView *_contentView;
    
    NSMutableArray *_myBezierPaths;
    StartPointView *_startPoint;
    
    UIBezierPath *_trackPath;
    CAShapeLayer *line;
    
    UIImageView *_birdView;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _myBezierPaths = [NSMutableArray new];
    
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _contentView.userInteractionEnabled = YES;

    [self setupStartAnimationButton];
    [self setupAddPointButton];
    [self setupLogCoordinatesButton];    
    
    //Add a signle start point
    _startPoint = [[StartPointView alloc] initWithPosition:CGPointMake(200, 200) pointNumber:0];  
    _startPoint.backgroundColor = [UIColor greenColor]; //give the startpoint a unique color
    _startPoint.delegate = self;
    [_contentView addSubview:_startPoint];
    
    //And add a single path
    MyBezierPath *path = [[MyBezierPath alloc] initWithViewParent:_contentView at:CGPointMake(300, 250)];
    path.delegate = self;    
    [_myBezierPaths addObject:path];
    
    [self updateDrawing];
    
    //A random image, used when animating along the path
    _birdView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bird.png"]];
    
    [self.view addSubview:_contentView];    
}

- (void)setupStartAnimationButton {
    UIButton *button = [self createButtonWithFrame:CGRectMake(10, 10, 100, 30) label:@"Animate"];
    [button addTarget:self action:@selector(animateButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:button];
}

- (void)setupAddPointButton {
    UIButton *button = [self createButtonWithFrame:CGRectMake(10, 50, 100, 30) label:@"Add point"];
    [button addTarget:self action:@selector(addPointButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:button];
}

- (void)setupLogCoordinatesButton {
    UIButton *button = [self createButtonWithFrame:CGRectMake(10, 90, 100, 30) label:@"NSLog points"];
    [button addTarget:self action:@selector(logCoordinatesButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:button];
}

- (UIButton *)createButtonWithFrame:(CGRect)frame label:(NSString *)label {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    button.backgroundColor = [UIColor blackColor];
    button.titleLabel.font = [UIFont systemFontOfSize:10];
    [button setTitle:label forState:UIControlStateNormal];
    return button;
}

- (void)animateButtonPressed {
    [self.view.layer addSublayer:_birdView.layer];
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
	anim.path = _trackPath.CGPath;
	anim.rotationMode = kCAAnimationRotateAuto;
	anim.repeatCount = HUGE_VALF;
	anim.duration = 5.0;
    anim.calculationMode = kCAAnimationPaced;
	[_birdView.layer addAnimation:anim forKey:@"fly"];
}

- (void)addPointButtonPressed {
    MyBezierPath *lastCurveView = [_myBezierPaths lastObject];
    CGPoint location = CGPointMake(lastCurveView.startPoint.center.x + 50, lastCurveView.startPoint.center.y + 50);
    if (location.x < 0) location.x = 0;
    if (location.x > SCREEN_WIDTH) location.x = SCREEN_WIDTH;
    if (location.y < 0) location.y = 0;
    if (location.y > SCREEN_HEIGHT) location.y = SCREEN_HEIGHT;
    
    MyBezierPath *myPath = [[MyBezierPath alloc] initWithViewParent:_contentView at:location];
    myPath.delegate = self;
    
    [_myBezierPaths addObject:myPath];
    [self updateDrawing];
}

- (void)updateDrawing {
    _trackPath = [UIBezierPath bezierPath];
	[_trackPath moveToPoint:_startPoint.center];    
    for (MyBezierPath *curveViewController in _myBezierPaths) {
        [_trackPath addCurveToPoint:curveViewController.startPoint.center
                      controlPoint1:curveViewController.controlPoint1.center
                      controlPoint2:curveViewController.controlPoint2.center];
    }
    
    if (line) {
        [line removeFromSuperlayer];
    }

    [_birdView.layer removeFromSuperlayer];
    
    line = [CAShapeLayer layer];
	line.path = _trackPath.CGPath;
	line.strokeColor = [UIColor blackColor].CGColor;
	line.fillColor = [UIColor clearColor].CGColor;
	line.lineWidth = 5.0;
	[_contentView.layer addSublayer:line];
}

# pragma mark - Debug log
- (void)logCoordinatesButtonPressed {
    NSMutableString *s = [NSMutableString new];
    [s appendString:@"\n*************CODE FOR CREATING THE PATH***************\n"];
    [s appendString:@"UIBezierPath *path = [UIBezierPath bezierPath];\n"];
    [s appendString:[NSString stringWithFormat:@"CGPoint pathStart = CGPointMake(%f, %f);\n", _startPoint.center.x, _startPoint.center.y]];
    [s appendString:@"[path moveToPoint:pathStart];\n"];
    
    for (MyBezierPath *path in _myBezierPaths) {
        NSString *startPoint = [NSString stringWithFormat:@"CGPointMake(pathStart.x + %i, pathStart.y + %i)",
                                (int)(path.startPoint.center.x - _startPoint.center.x),
                                (int)(path.startPoint.center.y - _startPoint.center.y)];
        NSString *cPoint1 = [NSString stringWithFormat:@"CGPointMake(pathStart.x + %i, pathStart.y + %i)",
                             (int)(path.controlPoint1.center.x - _startPoint.center.x),
                             (int)(path.controlPoint1.center.y - _startPoint.center.y)];
        NSString *cPoint2 = [NSString stringWithFormat:@"CGPointMake(pathStart.x + %i, pathStart.y + %i)",
                             (int)(path.controlPoint2.center.x - _startPoint.center.x),
                             (int)(path.controlPoint2.center.y - _startPoint.center.y)];
        
        [s appendString:[NSString stringWithFormat:@"[path addCurveToPoint:%@\n", startPoint]];
        [s appendString:[NSString stringWithFormat:@"        controlPoint1:%@\n", cPoint1]];
        [s appendString:[NSString stringWithFormat:@"        controlPoint2:%@];\n", cPoint2]];
    }
    
    [s appendString:@"\n******************** END *****************************\n"];
    NSLog(s, nil);
}

# pragma mark - MovableViewDeleage
- (void)touchEnded {
    [self updateDrawing];
}

# pragma mark - MovableViewDeleage
- (void)pathChanged {
    [self updateDrawing];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

@end
