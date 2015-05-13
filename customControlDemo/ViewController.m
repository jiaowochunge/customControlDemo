//
//  ViewController.m
//  customControlDemo
//
//  Created by john on 14-12-17.
//  Copyright (c) 2014年 ___coco-sh___. All rights reserved.
//

#import "ViewController.h"
#import "customControlDemo-Swift.h"

@interface ViewController ()

@property (nonatomic, weak) IBOutlet RatingView *rateView;
@property (nonatomic, weak) IBOutlet UILabel *score;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)rateViewValueChanged:(id)sender
{
    _score.text = [NSString stringWithFormat:@"%.1f", _rateView.rateScore];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
