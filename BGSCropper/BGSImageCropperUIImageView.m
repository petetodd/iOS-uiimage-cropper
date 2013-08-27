//
//  BGSImageCropperUIImageView.m
//  Image Editor
//
//  Created by Peter Todd on 27/08/2013.
//  Copyright (c) 2013 Bright Green Star. All rights reserved.
//

#import "BGSImageCropperUIImageView.h"
#import "BGSImageCropperCropView.h"

@implementation BGSImageCropperUIImageView{
    BOOL _dragging;
    float _oldX;
    float _oldY;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/



#pragma mark - Handle touches

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"DEBUG BGSImageCropperUIImageView Touches begin");

    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:touch.view];
    if ([[touch.view class] isSubclassOfClass:[BGSImageCropperCropView class]]) {
        _dragging = YES;
        _oldX = touchLocation.x;
        _oldY = touchLocation.y;

        
    }
    
    
    
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"DEBUG BGSImageCropperUIImageView Touches Moved");
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:touch.view];
     if ([[touch.view class] isSubclassOfClass:[BGSImageCropperCropView class]]) {
         BGSImageCropperCropView *cropView = (BGSImageCropperCropView *)touch.view;
         if (_dragging) {

             CGRect frame = cropView.frame;
             frame.origin.x = cropView.frame.origin.x + touchLocation.x - _oldX;
             frame.origin.y = cropView.frame.origin.y + touchLocation.y - _oldY;
             NSLog(@"DEBUG touchesMoved in crop view.  X : Y = %f : %f",frame.origin.x,frame.origin.y);
             // Constrain the crop view to the imageview
             if (frame.origin.x <0) frame.origin.x = 0;
             if (frame.origin.y <0) frame.origin.y = 0;
             NSLog(@"DEBUG touchesMoved in crop view.  X : Y = %f : %f",frame.origin.x,frame.origin.y);
             // x contraint
             float cropX = frame.origin.x + (frame.size.width);
             if(cropX > self.frame.size.width){
                 frame.origin.x = (self.frame.size.width - frame.size.width);
             }
             // y contraint (bottom)
             float cropY = frame.origin.y + (frame.size.height);
             if(cropY > self.frame.size.height){
                 frame.origin.y = (self.frame.size.height - frame.size.height);
             }


             cropView.frame = frame;
         }
         
     }
    

}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    _dragging = NO;
}

-(void)cropImageToCropper{
    NSLog(@"DEBUG BGSImageCropperUIImageView Touches Moved");

}



@end
