//
//  BGSImageSelectorVC.m
//  Image Editor
//
//  Created by Peter Todd on 25/08/2013.
//  Copyright (c) 2013 Bright Green Star. All rights reserved.
//

#import "BGSImageSelectorVC.h"
#import <AssetsLibrary/AssetsLibrary.h>


#define SOURCETYPE UIImagePickerControllerSourceTypeCamera


@interface BGSImageSelectorVC ()
    @property (strong, nonatomic) UIPopoverController *imageSelectionPopover;


@end

@implementation BGSImageSelectorVC{
    UIImage * _editedImage;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    
    if ([[segue identifier] isEqualToString:@"demoCrop"]) {
        BGSDemoCropView *destVC = [segue destinationViewController];
        destVC.delegate = self;
        if (_editedImage){
            destVC.selectedImage = _editedImage;
            
        }
    }
    
    
    
    
}

#pragma mark - Delegate Implementation
#pragma  mark BGSImageEditorVCDelegate
- (void)closeModalView{
    if (!([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)) {
        [self dismissViewControllerAnimated:(NO) completion:nil];
    }else{
        [self dismissViewControllerAnimated:(NO) completion:nil];
    }
}

- (void)editedImage:(UIImage *)imageEdited{
    [self.imageEdited setImage:imageEdited];
    [self closeModalView];
}


- (IBAction)butCameraAction:(id)sender {
    // Test if a camera exists
    if ([UIImagePickerController isSourceTypeAvailable:SOURCETYPE]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.delegate = self;
        picker.allowsEditing = NO;
        [picker setModalPresentationStyle:UIModalPresentationFullScreen];
        //  [self presentModalViewController:picker animated:YES];  - deprecated in ios6
        [self presentViewController:picker animated:YES completion:^{/* done */}];
        //  [self presentModalViewController:picker animated:YES];
        //    [self presentViewController:picker animated:YES completion:mo ];
    } else{
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: NSLocalizedString(@"No Camera Detected.",nil)
                              message: NSLocalizedString(@"You need a camera to take photos - BUT you can still use the Select option to pick from your Photos .",nil)
                              delegate: self
                              cancelButtonTitle: NSLocalizedString(@"OK",nil)
                              otherButtonTitles:nil];
        [alert show];
    }
    
    
    
    
    

}

- (IBAction)butImageSelectAction:(id)sender {
    [self performSegueWithIdentifier:@"demoCrop" sender:self];

}


#pragma mark - Camera And Picker Action

- (void)imagePickerAction:(id)sender {
    
    ALAuthorizationStatus photoAuthStatus = [ALAssetsLibrary authorizationStatus];
    
    if (photoAuthStatus == ALAuthorizationStatusAuthorized){ //Go ahead and Create - we have authorization
        // Authorized no action required
    } else if (photoAuthStatus == ALAuthorizationStatusRestricted) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: NSLocalizedString(@"Photo Library Access Restricted",nil)
                              message: NSLocalizedString(@"Access to your Photo Library is restricted.",nil)
                              delegate: self
                              cancelButtonTitle: NSLocalizedString(@"OK",nil)
                              otherButtonTitles:nil];
        [alert show];
        return;
        
        
    } else if (photoAuthStatus == ALAuthorizationStatusDenied) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: NSLocalizedString(@"Photo Library Access Denied",nil)
                              message: NSLocalizedString(@"You have denied Property Flyer access to your Photo Library.  If you would like to grant access please amend the privacy setting for Photo Library in your Settings.",nil)
                              delegate: self
                              cancelButtonTitle: NSLocalizedString(@"OK",nil)
                              otherButtonTitles:nil];
        [alert show];
        return;
        
    }
    
    
    
    
    if([UIImagePickerController isSourceTypeAvailable:
        UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.delegate = self;
        picker.allowsEditing = NO;
        // If an iPad must present in Popover
        // For iPad need to ensure correct detail shoing
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            self.imageSelectionPopover = [[UIPopoverController alloc] initWithContentViewController:picker];
            self.imageSelectionPopover.delegate = self;
            [self.imageSelectionPopover presentPopoverFromBarButtonItem:((UIBarButtonItem*) sender) permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }else{
            //  [self presentModalViewController:picker animated:YES];  - deprecated in ios6
            [picker setModalPresentationStyle:UIModalPresentationFullScreen];
            [self presentViewController:picker animated:YES completion:^{/* done */}];
        }
        
    }
}


#pragma mark - Image and Camera


// For responding to the user tapping Cancel.
- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker {
    [picker dismissViewControllerAnimated:NO completion:nil];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    //    NSLog(@"DEBUG didFinishPickingMediaWithInfo");
    
    _editedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self.imageEdited setImage:_editedImage];

    if ([self imageSelectionPopover]){
        [self.imageSelectionPopover dismissPopoverAnimated:YES];
        [self setImageSelectionPopover:Nil];
    }else{
        [picker dismissViewControllerAnimated:(NO) completion:nil];
    }
    [self performSegueWithIdentifier:@"demoCrop" sender:self];

}

@end
