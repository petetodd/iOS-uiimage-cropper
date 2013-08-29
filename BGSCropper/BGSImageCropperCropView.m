//
//  BGSImageCropperCropView.m
//  Image Editor
//
//  Created by Peter Todd on 27/08/2013.
//  Copyright (c) 2013 Bright Green Star. All rights reserved.
//

#import "BGSImageCropperCropView.h"
#import "BGSImageCropperHandlesView.h"

@implementation BGSImageCropperCropView{
  //  BGSImageCropperHandlesView * _handleLowerRight;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self addCropperHandles];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
/*
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    }
 */


// Add resize handles
-(void)addCropperHandles{
    // Size the handles based on cropper size
    float widthHandle = (self.frame.size.width * 0.1);
    if (widthHandle < MINIMUM_CROP_HANDLE_SIZE) widthHandle = MINIMUM_CROP_HANDLE_SIZE;
    
    //top left
    CGRect rectCornerLeft = CGRectMake(0 ,0, widthHandle,widthHandle);
    BGSImageCropperHandlesView *handleTopLeft = [[BGSImageCropperHandlesView alloc]initWithFrame:rectCornerLeft];
    [handleTopLeft setHandleType:@"TOPLEFT"];
    [self addSubview:handleTopLeft];
    
    
    // if the view is being cropped from the top right then the lower left will be constantly changing
    // we want to avoid draging this box around the view 
    
 //   if (([self.cropDirection isEqualToString:@"LOWERRIGHT"]) || (!self.cropDirection) ){
        //LOWERRIGHT
        CGRect rectCornerLowerRight = CGRectMake((self.frame.size.width - widthHandle) ,(self.frame.size.height - widthHandle), widthHandle,widthHandle);
        BGSImageCropperHandlesView * handleLowerRight = [[BGSImageCropperHandlesView alloc]initWithFrame:rectCornerLowerRight];
        [handleLowerRight setHandleType:@"LOWERRIGHT"];
        [self addSubview:handleLowerRight];
//    }
}

-(void)removeCropperHandles{
    // Remove subviews
    NSMutableArray * objectsToRemove = [[NSMutableArray alloc]init];
    for (int i= 0;i < self.subviews.count; i++){
        if ([[self.subviews objectAtIndex:i] isKindOfClass:[BGSImageCropperHandlesView class]]){
            [objectsToRemove addObject:[self.subviews objectAtIndex:i]];
        }
    }
    
    for (int i=0;i < objectsToRemove.count; i++){
        [[objectsToRemove objectAtIndex:i] removeFromSuperview];
        
    }

}

-(void)removeCropHandle:(NSString *)handleType{
    NSMutableArray * objectsToRemove = [[NSMutableArray alloc]init];
    for (int i= 0;i < self.subviews.count; i++){
        if ([[self.subviews objectAtIndex:i] isKindOfClass:[BGSImageCropperHandlesView class]]){
            [objectsToRemove addObject:[self.subviews objectAtIndex:i]];
        }
    }
    
    for (int i=0;i < objectsToRemove.count; i++){
        if ([[(BGSImageCropperHandlesView *) [objectsToRemove objectAtIndex:i] handleType] isEqualToString:handleType]){
            if ([handleType isEqualToString:@"LOWERRIGHT"]){
                // Always remove lowe right as otherwise it hangs in previous position (got to be a better way to handle this!)
                [[objectsToRemove objectAtIndex:i] removeFromSuperview];
            }
        }else{
            [[objectsToRemove objectAtIndex:i] removeFromSuperview];

        }
        
    }
    
    
    
}






@end
