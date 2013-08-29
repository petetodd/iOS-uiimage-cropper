//
//  BGSImageCropperHandlesView.m
//  Image Editor
//
//  Created by Peter Todd on 28/08/2013.
//  Copyright (c) 2013 Bright Green Star. All rights reserved.
//

#import "BGSImageCropperHandlesView.h"

@implementation BGSImageCropperHandlesView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor blueColor]];
        [self setAlpha:0.4];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    // The top left handle

    if ([self.handleType isEqualToString:@"TOPLEFT"]){
        // Do some shading of handle box

        CGRect loweSideRect = CGRectMake(rect.origin.x, rect.origin.y, (rect.size.width / 2), (rect.size.height /10));
        CGRect upperSideRect = CGRectMake(rect.origin.x, rect.origin.y, (rect.size.width /10), (rect.size.height /2));
     //   CGRect rectLine = CGRectMake((rect.size.width / 2), (rect.size.height/2), (rect.size.width /10), (rect.size.height /2));
        [[UIColor redColor] set];
        UIRectFill(loweSideRect);
        UIRectFill(upperSideRect);
    //    UIRectFill(rectLine);
    }
   
    if ([self.handleType isEqualToString:@"LOWERRIGHT"]){
        CGRect loweSideRect = CGRectMake((rect.size.width / 2), (rect.origin.y + (rect.size.height *.9)), (rect.size.width /2), (rect.size.height /10));
        CGRect upperSideRect = CGRectMake((rect.origin.x +(rect.size.width * .9)), (rect.size.width / 2), (rect.size.width /10), (rect.size.height / 2));
        
        [[UIColor redColor] set];
        UIRectFill(loweSideRect);
        UIRectFill(upperSideRect);
    }
   
}


@end
