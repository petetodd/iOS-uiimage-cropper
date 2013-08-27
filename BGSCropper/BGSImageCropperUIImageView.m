//
//  BGSImageCropperUIImageView.m
//  Image Editor
//
//  Created by Peter Todd on 27/08/2013.
//  Copyright (c) 2013 Bright Green Star. All rights reserved.
//

#import "BGSImageCropperUIImageView.h"

@implementation BGSImageCropperUIImageView{
    BOOL _dragging;
    BOOL _resizeCropRect;
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
 //   NSLog(@"DEBUG BGSImageCropperUIImageView Touches begin");

    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:touch.view];
    
    // Determine if this is a drag of the crop box or a resize (be dragging corners0
    // A resize will 
    if (self.isCropModeOn){
        if ([[touch.view class] isSubclassOfClass:[BGSImageCropperCropView class]]) {
            _oldX = touchLocation.x;
            _oldY = touchLocation.y;
            // Uses a buffer on the edges define if this is a drag or resize
            if ((_oldX <= RESIZE_EDGE_MARGIN) || ((self.cropView.frame.size.width - _oldX) <= RESIZE_EDGE_MARGIN) ){
                NSLog(@"DEBUG Resize on X");
                _resizeCropRect = YES;
                _dragging = NO;
            } else if ((_oldY <= RESIZE_EDGE_MARGIN) || ((self.cropView.frame.size.height - _oldY) <= RESIZE_EDGE_MARGIN) ){
                NSLog(@"DEBUG Resize on Y");

                _resizeCropRect = YES;
                _dragging = NO;
            } else{
                _dragging = YES;
                _resizeCropRect = NO;
            }
//            NSLog(@"DEBUG touchLocation in crop view.  X : Y = %f : %f",touchLocation.x,touchLocation.y);

        }else{ //Its a resize as touched outside crop box
            _resizeCropRect = YES;
            _dragging = NO;
        }
        
        
        
    }

    
    
    
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
 //   NSLog(@"DEBUG BGSImageCropperUIImageView Touches Moved");
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:touch.view];
    
    
    
     if ([[touch.view class] isSubclassOfClass:[BGSImageCropperCropView class]]) {
         self.cropView = (BGSImageCropperCropView *)touch.view;
         if (_dragging) {

             CGRect frame = self.cropView.frame;
             frame.origin.x = self.cropView.frame.origin.x + touchLocation.x - _oldX;
             frame.origin.y = self.cropView.frame.origin.y + touchLocation.y - _oldY;
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


             self.cropView.frame = frame;
         } else if(_resizeCropRect){
             
             CGRect frame = self.cropView.frame;
             // x adjustment
             // May have to move origin AND  change width
             NSLog(@"DEBUG RESIZE touchesMoved in crop view.  _oldX : _oldY = %f : %f",_oldX,_oldY);
             NSLog(@"DEBUG RESIZE touchLocation in crop view.  touchLocationX : touchLocationY = %f : %f",touchLocation.x ,touchLocation.y);


             if (_oldX <= RESIZE_EDGE_MARGIN &&(self.cropView.frame.size.width > RESIZE_EDGE_MARGIN) &&(self.cropView.frame.size.height > RESIZE_EDGE_MARGIN) ){
   //          if ((_oldX <= RESIZE_EDGE_MARGIN) || ((self.cropView.frame.size.width - _oldX) <= RESIZE_EDGE_MARGIN) ){
    
                 if ( (self.cropView.frame.size.width - (touchLocation.x -_oldX)) >= (2* RESIZE_EDGE_MARGIN)){
                     frame.origin.x = self.cropView.frame.origin.x + touchLocation.x - _oldX;
                     frame.size.width = (self.cropView.frame.size.width - (touchLocation.x -_oldX));
                 }
             } else if (((self.cropView.frame.size.width - _oldX) <= RESIZE_EDGE_MARGIN)) {
                 if ( (self.cropView.frame.size.width - (touchLocation.x -_oldX)) >= (2* RESIZE_EDGE_MARGIN)){
                     frame.size.width = (self.cropView.frame.size.width + (touchLocation.x - _oldX));
                 }
             }
             
       //      if (_oldX > )
             
             if (_oldY <= RESIZE_EDGE_MARGIN &&(self.cropView.frame.size.height > RESIZE_EDGE_MARGIN)&&(self.cropView.frame.size.width > RESIZE_EDGE_MARGIN) ){
                 if ( (self.cropView.frame.size.height - (touchLocation.y - _oldY)) >= (2* RESIZE_EDGE_MARGIN)){
                     frame.origin.y = self.cropView.frame.origin.y + touchLocation.y - _oldY;
                     frame.size.height = (self.cropView.frame.size.height - (touchLocation.y - _oldY));
                 }
             }
             
        //     NSLog(@"DEBUG touchesMoved in crop view.  X : Y = %f : %f",frame.origin.x,frame.origin.y);
             // Constrain the crop view to the imageview
             if (frame.origin.x <0) frame.origin.x = 0;
             if (frame.origin.y <0) frame.origin.y = 0;
        //     NSLog(@"DEBUG touchesMoved in crop view.  X : Y = %f : %f",frame.origin.x,frame.origin.y);
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
             
             
             self.cropView.frame = frame;

             
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
