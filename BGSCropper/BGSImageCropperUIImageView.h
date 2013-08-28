//
//  BGSImageCropperUIImageView.h
//  Image Editor
//
//  Created by Peter Todd on 27/08/2013.
//  Copyright (c) 2013 Bright Green Star. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BGSImageCropperCropView.h"

#define RESIZE_EDGE_MARGIN 35.0f


@interface BGSImageCropperUIImageView : UIImageView

@property BOOL isCropModeOn;

@property (strong, nonatomic) BGSImageCropperCropView * cropView;

@end
