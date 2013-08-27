//
//  BGSDemoCropView.h
//  Image Editor
//
//  Created by Peter Todd on 26/08/2013.
//  Copyright (c) 2013 Bright Green Star. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BGSImageCropper.h"

@protocol BGSDemoCropViewDelegate
- (void)closeModalView;
- (void)editedImage:(UIImage *)imageEdited;
@end


@interface BGSDemoCropView : UIViewController

@property (weak) id <BGSDemoCropViewDelegate> delegate;

@property (strong, nonatomic) UIImage *selectedImage;

- (IBAction)butCancelAction:(id)sender;
- (IBAction)butSaveAction:(id)sender;

@property (weak, nonatomic) IBOutlet BGSImageCropper *viewBGSImageCropper;

@end
