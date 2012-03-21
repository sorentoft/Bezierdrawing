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
    UIButton *animateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    animateButton.frame = CGRectMake(10, 10, 100, 30);
    animateButton.backgroundColor = [UIColor blackColor];
    [animateButton setTitle:@"Animate" forState:UIControlStateNormal];
    [animateButton addTarget:self action:@selector(animateButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:animateButton];
}

- (void)setupAddPointButton {
    UIButton *addPointButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addPointButton.frame = CGRectMake(10, 50, 100, 30);
    addPointButton.backgroundColor = [UIColor blackColor];
    [addPointButton setTitle:@"Add point" forState:UIControlStateNormal];
    [addPointButton addTarget:self action:@selector(addPointButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:addPointButton];    
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
