//
//  KEVViewController.h
//  Expense
//
//  Created by Kevin Clark on 2014-03-22.
//  Copyright (c) 2014 Kevin Clark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <ImageIO/ImageIO.h>
#import <CTAssetsPickerController.h>
#import <FBShimmeringView.h>

@interface KEVViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, CTAssetsPickerControllerDelegate>

@property (strong, atomic) ALAssetsLibrary* library;
@property (nonatomic) NSDate *pickerDate;

@end
