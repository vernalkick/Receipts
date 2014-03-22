//
//  KEVViewController.m
//  Expense
//
//  Created by Kevin Clark on 2014-03-22.
//  Copyright (c) 2014 Kevin Clark. All rights reserved.
//

#import "KEVViewController.h"

@interface KEVViewController ()

@end

@implementation KEVViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *takePicture = [[UIButton alloc] initWithFrame:CGRectMake(0, 100, 320, 60)];
    [takePicture setTitle:@"Take a Picture" forState:UIControlStateNormal];
    [takePicture setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [takePicture addTarget:self action:@selector(takePicture:) forControlEvents:UIControlEventTouchDown];
    
    [self.view addSubview:takePicture];


}

-(void)takePicture:(UIButton *)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    UIImageWriteToSavedPhotosAlbum(*chosenImage, NULL, NULL, )
    //self.imageView.image = chosenImage;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}




@end
