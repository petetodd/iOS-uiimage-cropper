//
//  BGSImageCropperCropView.h
//  Image Editor
//
//  Created by Peter Todd on 27/08/2013.
//  Copyright (c) 2013 Bright Green Star. All rights reserved.
//

#import <UIKit/UIKit.h>
#define MINIMUM_CROP_HANDLE_SIZE 40.0f

@interface BGSImageCropperCropView : UIView

//@property (strong,nonatomic) NSString *cropDirection;

-(void)addCropperHandles;

-(void)removeCropperHandles;

-(void)removeCropHandle:(NSString *)handleType;



@end
