//
//  BGSImageCropper.h
//  Image Editor
//
//  Created by Peter Todd on 26/08/2013.
//  Copyright (c) 2013 Bright Green Star. All rights reserved.
//

#import <UIKit/UIKit.h>


#define TOP_AND_BOTTOM_MARGIN 5.0f
#define SIDE_MARGIN 5.0f

#define MAX_CONTROL_BAR_HEIGHT 50.0f


@interface BGSImageCropper : UIView

- (void)setupUIImageView:(UIImage*)inImage;

- (void)simpleControlBar;

@property BOOL isCropModeOn;


@end
