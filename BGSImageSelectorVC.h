//
//  BGSImageSelectorVC.h
//  Image Editor
//
//  Created by Peter Todd on 25/08/2013.
//  Copyright (c) 2013 Bright Green Star. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BGSDemoCropView.h"

@interface BGSImageSelectorVC : UIViewController<BGSDemoCropViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIPopoverControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageEdited;
- (IBAction)butCameraAction:(id)sender;
- (IBAction)butImageSelectAction:(id)sender;
@end
