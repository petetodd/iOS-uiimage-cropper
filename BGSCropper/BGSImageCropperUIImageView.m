//
//  BGSImageCropperUIImageView.m
//  Image Editor
//
//  Created by Peter Todd on 27/08/2013.
//  Copyright (c) 2013 Bright Green Star. All rights reserved.
//

#import "BGSImageCropperUIImageView.h"
#import "BGSImageCropperHandlesView.h"

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
    NSLog(@"DEBUG [touch.view class] : %@",[touch.view class]);

    if ([[touch.view class] isSubclassOfClass:[BGSImageCropperHandlesView class]]) {
        NSLog(@"DEBUG touchesMoved BGSImageCropperHandlesView");
        [self setIsCropModeOn:YES];
        CGRect frame = self.cropView.frame;

        BGSImageCropperHandlesView *cropHandle = (BGSImageCropperHandlesView *) touch.view;
        if ([cropHandle.handleType isEqualToString:@"TOPLEFT"]){
            // Top left is 0,0
            _oldX = 0;
            _oldY = 0;
            [self.cropView removeCropHandle:@"TOPLEFT"];
                 
            if ( (self.cropView.frame.size.width - (touchLocation.x -_oldX)) >= (2* RESIZE_EDGE_MARGIN)){
                frame.origin.x = self.cropView.frame.origin.x + touchLocation.x - _oldX;
                frame.size.width = (self.cropView.frame.size.width - (touchLocation.x -_oldX));
            }
            

            
            if ( (self.cropView.frame.size.height - (touchLocation.y - _oldY)) >= (2* RESIZE_EDGE_MARGIN)){
                if ((self.cropView.frame.origin.y + touchLocation.y - _oldY) > 0){
                    frame.origin.y = self.cropView.frame.origin.y + touchLocation.y - _oldY;
                    frame.size.height = (self.cropView.frame.size.height - (touchLocation.y - _oldY));
                }
            }
        

        }
        
        if ([cropHandle.handleType isEqualToString:@"LOWERRIGHT"]){
            float xMovement = 1;
            float yMovement = 1;

            NSLog(@"DEBUG touchLocation.x : %f",touchLocation.x);
            NSLog(@"DEBUG _oldX : %f",_oldX);

            if (_oldX == 0){
                _oldX = touchLocation.x;
            }
            
            if (_oldX >touchLocation.x){
                xMovement = -1* abs(_oldX - touchLocation.x);
            }else{
                xMovement = abs(_oldX - touchLocation.x);
            }
            NSLog(@"DEBUG xMovement : %f",xMovement);
            _oldX = touchLocation.x;
            
           // [self.cropView removeCropHandle:@"LOWERRIGHT"];
            if ((self.cropView.frame.size.width + xMovement) >= (2* RESIZE_EDGE_MARGIN)){
                // Need to ensurwidth does not exceed image view
                float widthConstraint = self.cropView.frame.origin.x + (self.cropView.frame.size.width + xMovement);
                if (widthConstraint >= self.frame.size.width){
                    // Do nothing - possible an alert or flare the sides of crop box to indicate edge
                }else{
                    frame.size.width = (self.cropView.frame.size.width + xMovement);               
                }
            }
                        
            if (_oldY == 0){
                _oldY = touchLocation.y;
            }
            
            if (_oldY >touchLocation.y){
                yMovement = -1* abs(_oldY - touchLocation.y);
            }else{
                yMovement = abs(_oldY - touchLocation.y);
            }
            NSLog(@"DEBUG yMovement : %f",yMovement);
            
            _oldY = touchLocation.y;
            //Height
            if ((self.cropView.frame.size.height + yMovement) >= (2* RESIZE_EDGE_MARGIN)){
                // Need to ensurwidth does not exceed image view
                float heightConstraint = self.cropView.frame.origin.y + (self.cropView.frame.size.height + yMovement);
                if (heightConstraint >= self.frame.size.height){
                    // Do nothing - possible an alert or flare the sides of crop box to indicate edge
                }else{
                    frame.size.height = (self.cropView.frame.size.height + yMovement);
                }
            }
            
            
        }
        
        
        
        
  /*
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
        
     //   [self.cropView drawRect:frame];
        */
        self.cropView.frame = frame;
        [self.cropView setNeedsDisplay];

        
  
    }

    
    
     if ([[touch.view class] isSubclassOfClass:[BGSImageCropperCropView class]]) {
         self.cropView = (BGSImageCropperCropView *)touch.view;
         if (_dragging) {

             CGRect frame = self.cropView.frame;
             frame.origin.x = self.cropView.frame.origin.x + touchLocation.x - _oldX;
             frame.origin.y = self.cropView.frame.origin.y + touchLocation.y - _oldY;
       //      NSLog(@"DEBUG touchesMoved in crop view.  X : Y = %f : %f",frame.origin.x,frame.origin.y);
             // Constrain the crop view to the imageview
             if (frame.origin.x <0) frame.origin.x = 0;
             if (frame.origin.y <0) frame.origin.y = 0;
       //      NSLog(@"DEBUG touchesMoved in crop view.  X : Y = %f : %f",frame.origin.x,frame.origin.y);
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
 //   if (self.isCropModeOn){
 //       [self setIsCropModeOn:NO];
 //   }
    [self.cropView removeCropperHandles];
    [self.cropView addCropperHandles];
    _oldX = 0;
    _oldY = 0;

    NSLog(@"DEBUG BGSImageCropperUIImageView touchesEnded");

}

-(void)cropImageToCropper{
    NSLog(@"DEBUG BGSImageCropperUIImageView Touches Moved");

}



@end
