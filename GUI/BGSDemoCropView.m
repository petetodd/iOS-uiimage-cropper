//
//  BGSDemoCropView.m
//  Image Editor
//
//  Created by Peter Todd on 26/08/2013.
//  Copyright (c) 2013 Bright Green Star. All rights reserved.
//

#import "BGSDemoCropView.h"

@interface BGSDemoCropView ()

@end

@implementation BGSDemoCropView

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

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self.viewBGSImageCropper setupUIImageView:[self selectedImage]];
  
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)butCancelAction:(id)sender {
    [self.delegate closeModalView];

}

- (IBAction)butSaveAction:(id)sender {
    [self.delegate editedImage:[self selectedImage]];

}
@end
