//
//  NBRateView.m
//  Ufingernail
//
//  Created by john on 14-12-17.
//  Copyright (c) 2014年 ___coco-sh___. All rights reserved.
//

#import "NBRateView.h"

#define SimpleCode 0

//you can set SimpleCode 1. the code can also run, but you can't preview the control in storyboard

@interface NBRateView ()

#if SimpleCode
@property (nonatomic, strong) NSMutableArray *allRateImageView;
#endif
@property (nonatomic, assign) id target;
@property (nonatomic, assign) SEL selector;

@end

CGFloat const NBRINSET = 2;

@implementation NBRateView

#if SimpleCode
- (void)additionalInit
{
    self.allRateImageView = [NSMutableArray arrayWithCapacity:_maxCount];
    CGFloat elementWidth = _eleWidth;
    CGFloat elementHeight = _eleWidth;
    if (!_eleWidth) {
        elementWidth = _enableImage.size.width;
        elementHeight = _enableImage.size.height;
    }
    for (int i = 0; i != _maxCount; ++i) {
        UIImageView *element = [[UIImageView alloc] initWithFrame:CGRectMake(NBRINSET + (NBRINSET + elementWidth) * i, NBRINSET, elementWidth, elementHeight)];
        element.image = _disableImage;
        element.highlightedImage = _enableImage;
        [self addSubview:element];
        [_allRateImageView addObject:element];
    }
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self additionalInit];
}

#else

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //翻转坐标系
    CGContextTranslateCTM(ctx, 0.0, rect.size.height);
    CGContextScaleCTM(ctx, 1.0, -1.0);
    //评分元素大小
    CGFloat elementWidth = _eleWidth;
    CGFloat elementHeight = _eleWidth;
    if (!_eleWidth) {
        elementWidth = _enableImage.size.width;
        elementHeight = _enableImage.size.height;
    }
    for (int i = 0; i != _maxCount; ++i) {
        CGRect imgFrame = CGRectMake(NBRINSET + (NBRINSET + elementWidth) * i, NBRINSET, elementWidth, elementHeight);
        CGImageRef paintImg = i < _rateScore ? _enableImage.CGImage : _disableImage.CGImage;
        CGContextDrawImage(ctx, imgFrame, paintImg);
    }
}

#endif


- (void)setRateScore:(NSUInteger)rateScore
{
    _rateScore = rateScore;
#if SimpleCode
    for (int i = 0; i != _allRateImageView.count; ++i) {
        UIImageView *image = [_allRateImageView objectAtIndex:i];
        if (i < rateScore) {
            image.highlighted = YES;
        } else {
            image.highlighted = NO;
        }
    }
#else
    [self setNeedsDisplay];
#endif
}

- (void)setTarget:(id)target forValueChangeAction:(SEL)action
{
    self.target = target;
    self.selector = action;
}

//计算默认尺寸
- (CGSize)intrinsicContentSize
{
    if (_eleWidth) {
        return CGSizeMake((NBRINSET + _eleWidth) * _maxCount + NBRINSET, NBRINSET * 2 + _eleWidth);
    } else {
        return CGSizeMake((NBRINSET + _enableImage.size.width) * _maxCount + NBRINSET, NBRINSET * 2 + _enableImage.size.height);
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!_allowEdit) {
        return;
    }
    CGPoint pt = [[touches anyObject] locationInView:self];
    CGFloat eleWidth = _eleWidth;
    if (!_eleWidth) {
        eleWidth = _enableImage.size.width;
    }
    CGFloat score = (pt.x - NBRINSET) / (eleWidth + NBRINSET);
    if (score > 0) {
        self.rateScore = score + 1;
    } else {
        self.rateScore = 0;
    }
    if (_target) {
        IMP imp = [_target methodForSelector:_selector];
        void (*func)(id, SEL, id) = (void *)imp;
        func(_target, _selector, self);
    }
}

@end
