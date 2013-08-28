//
//  BGSImageCropper.m
//  Image Editor
//
//  Created by Peter Todd on 26/08/2013.
//  Copyright (c) 2013 Bright Green Star. All rights reserved.
//

#import "BGSImageCropper.h"
#import "BGSImageCropperUIImageView.h"
#import "BGSImageCropperCropView.h"
#import <QuartzCore/QuartzCore.h>


@implementation BGSImageCropper{
    BGSImageCropperUIImageView * _imageView;
    UIImage * _selectedImage;
    BGSImageCropperCropView * _cropView;
    BOOL _isZoomed;
    BOOL _isInCropMode;
    float _imageScale;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}



- (void)setupUIImageView:(UIImage*)inImage{
    _selectedImage = inImage;

    int bottomViewHeight = 50;
    CGRect imageRect = CGRectMake(5, 5, (self.bounds.size.width - 10), (self.bounds.size.height - (bottomViewHeight + 10)));

    _imageView = [[BGSImageCropperUIImageView alloc] initWithFrame:imageRect];
    [_imageView setUserInteractionEnabled:YES];
    
    
 //   NSLog(@"DEBUG frame width: %f",self.bounds.size.width);
 //   NSLog(@"DEBUG frame height: %f",self.bounds.size.height);


    
    [self setBackgroundColor:[UIColor blueColor]];
    [_imageView setBackgroundColor:[UIColor redColor]];
    [self drawPhotoInRect:[_imageView frame] drawPhoto:inImage];

    [self addSubview:_imageView];
    
    //Set as required
    [self setIsCropModeOn:YES];
    
    if (self.isCropModeOn){
        [self drawCropBox];
    }

}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark - Crop Box

-(void)drawCropBox{
    [_imageView setIsCropModeOn:[self isCropModeOn]];
    //Set box in centre of image and set to a 1/4 width and height imageview
    int origX = (_imageView.frame.size.width/2) - (_imageView.frame.size.width/4);
    int origY = (_imageView.frame.size.height/2) - (_imageView.frame.size.height/4);

    CGRect cropRect = CGRectMake(origX, origY, (_imageView.frame.size.width/2), (_imageView.frame.size.height/2));
    _cropView = [[BGSImageCropperCropView alloc]initWithFrame:cropRect];
    [_cropView setBackgroundColor:[UIColor grayColor]];
    [_cropView setAlpha:0.7];
    [_imageView addSubview:_cropView];
    [_imageView setCropView:_cropView];
    // Ad gesture recog
    [self configGesturesCropBox];
    

    
}

- (void) configGesturesCropBox{
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    [doubleTap setNumberOfTapsRequired:2];  //Should always be called even if > 1 tap
    [_cropView setUserInteractionEnabled:YES];
    [_cropView addGestureRecognizer:doubleTap];
}

-(void)handleDoubleTap:(UIGestureRecognizer*)gestureView{
    NSLog(@"DEBUG handleDoubleTap Crop Box");
    // Now we need to crop the image to the box
    _selectedImage = [self imageByCropping:_selectedImage toRect:_cropView.frame];
    [self setupUIImageView:_selectedImage];
}



- (UIImage*)imageByCropping:(UIImage *)imageToCrop toRect:(CGRect)rect

{
    //scale up our cropper rect
    float cropX;
    float cropY;
    float cropWidth;
    float cropHeight;
    cropX = rect.origin.x * _imageScale;
    cropY = rect.origin.y * _imageScale;
    cropHeight = rect.size.height *_imageScale;
    cropWidth = rect.size.width * _imageScale;
    
    // Make the clipped rect origin 0,0
    CGRect clippedRect = CGRectMake(0, 0, cropWidth, cropHeight);
    
    UIGraphicsBeginImageContext(clippedRect.size);
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    CGContextClipToRect( currentContext, clippedRect);

    CGRect drawRect = CGRectMake(cropX * -1,
                                 cropY * -1,
                                 imageToCrop.size.width,
                                 imageToCrop.size.height);
    
    // draw image
    [imageToCrop drawInRect:drawRect];
    
    // grab image
    UIImage* croppedImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return croppedImage;

}



#pragma mark - Image Size and Ratio
- (void)drawPhotoInRect:(CGRect)photoRect drawPhoto:(UIImage*)photoToDraw{
    
    CGSize imageSize = photoToDraw.size;
    // fminf - minimum of 2 floating point numbers
    // imgscale will be the smaller of the 2 ratios e.g. if a tall thin image than height will be taller than
    // photorect so that will be the smallest float
    CGFloat imageScale = fminf(photoRect.size.width/imageSize.width, photoRect.size.height/imageSize.height);
    CGSize scaledImageSize = CGSizeMake(imageSize.width*imageScale, imageSize.height*imageScale); // Scale the image
    // The scaling should ensure the image does not fall outside the bounding CGRECT
    // But need to adjust the origin to centre the image
    float revisedXOrigin = photoRect.origin.x + (photoRect.size.width /2) - (scaledImageSize.width /2);
    float revisedYOrigin = photoRect.origin.y + (photoRect.size.height /2) - (scaledImageSize.height /2);
    
    CGRect imageFrame = CGRectMake(revisedXOrigin, revisedYOrigin, scaledImageSize.width, scaledImageSize.height);
    [_imageView setFrame:imageFrame];
    [_imageView setImage:photoToDraw];
    _imageScale = (1/ imageScale);
    
}

@end
