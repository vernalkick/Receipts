//
//  KEVViewController.m
//  Expense
//
//  Created by Kevin Clark on 2014-03-22.
//  Copyright (c) 2014 Kevin Clark. All rights reserved.
//

#import "KEVViewController.h"
#import "ALAssetsLibrary+CustomPhotoAlbum.h"

@interface KEVViewController ()

@end

@implementation KEVViewController
@synthesize library;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.library = [[ALAssetsLibrary alloc] init];
    
    UIColor *blue = [UIColor colorWithRed:23/255.0f green:138/255.0f blue:255/255.0f alpha:1.0f];
    
    UILabel *receipts = [[UILabel alloc] initWithFrame:CGRectMake(0, 130, 320, 70)];
    receipts.text = @"Receipts";
    receipts.textAlignment = NSTextAlignmentCenter;
    receipts.textColor = blue;
    receipts.font = [UIFont fontWithName:@"HelveticaNeue-thin" size:60];
    [self.view addSubview:receipts];
    
    UILabel *subtitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 200, 320, 30)];
    subtitle.text = @"Never forget to log your lunch";
    subtitle.textAlignment = NSTextAlignmentCenter;
    subtitle.textColor = [UIColor colorWithWhite:0 alpha:0.4f];
    subtitle.font = [UIFont fontWithName:@"HelveticaNeue-light" size:18];
    [self.view addSubview:subtitle];
    
    UIButton *selectPicture = [[UIButton alloc] initWithFrame:CGRectMake(20, 385, 280, 55)];
    [selectPicture setTitle:@"Choose from library" forState:UIControlStateNormal];
    selectPicture.backgroundColor = blue;
    selectPicture.layer.cornerRadius = 8;
    [selectPicture setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [selectPicture addTarget:self action:@selector(selectPicture:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:selectPicture];

    
    UIButton *takePicture = [[UIButton alloc] initWithFrame:CGRectMake(20, 460, 280, 55)];
    takePicture.layer.cornerRadius = 8;
    takePicture.layer.borderWidth = 1.0;
    takePicture.layer.borderColor = blue.CGColor;
    [takePicture setTitle:@"Take a Picture" forState:UIControlStateNormal];
    [takePicture setTitleColor:blue forState:UIControlStateNormal];
    [takePicture addTarget:self action:@selector(takePicture:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:takePicture];
    

}

- (void)viewDidUnload {
    self.library = nil;
    [super viewDidUnload];
}

-(void)takePicture:(UIButton *)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

-(void)selectPicture:(UIButton *)sender {
    CTAssetsPickerController *picker = [[CTAssetsPickerController alloc] init];
    picker.delegate = self;
    picker.assetsFilter = [ALAssetsFilter allPhotos];
    [self presentViewController:picker animated:YES completion:NULL];
}



-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
    

        NSDate *date = [NSDate date];
        
        NSLog(@"Picture taken: %@", date);
        
        NSDate *nextMonday = [self previousMondayFromDate:date];
        NSDate *nextFriday = [self nextFridayFromDate:date];
        
        NSDateFormatter *prettyDate = [[NSDateFormatter alloc] init];
        [prettyDate setDateFormat:@"LLLL d"];
        
        NSString *folderName = [@"Receipt - " stringByAppendingString:[[[prettyDate stringFromDate:nextMonday] stringByAppendingString:@" - "] stringByAppendingString:[prettyDate stringFromDate:nextFriday]]];
        
        NSLog(@"FOLDER NAME: %@", folderName);
        NSLog(@"%@", image);
        
        [self.library saveImage:image toAlbum:folderName completion:nil failure:nil];

    
    
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}


- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets  {
    
    for (id image in assets) {

    
        NSDate *date = [image valueForProperty:ALAssetPropertyDate];
        
        NSDate *nextMonday = [self previousMondayFromDate:date];
        NSDate *nextFriday = [self nextFridayFromDate:date];

        
        NSDateFormatter *prettyDate = [[NSDateFormatter alloc] init];
        [prettyDate setDateFormat:@"LLLL d"];
        
        NSString *folderName = [@"Receipt - " stringByAppendingString:[[[prettyDate stringFromDate:nextMonday] stringByAppendingString:@" - "] stringByAppendingString:[prettyDate stringFromDate:nextFriday]]];
        
        UIImage *img = [UIImage imageWithCGImage:[[image defaultRepresentation] fullResolutionImage]];
        
        [self.library saveImage:img toAlbum:folderName completion:nil failure:nil];
       
    }
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}


-(NSDate *)previousMondayFromDate:(NSDate *)date {
    //NSDate *today = [[NSDate alloc] init];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    // Get the weekday component of the current date
    NSDateComponents *weekdayComponents = [gregorian components:NSWeekdayCalendarUnit fromDate:date];
    
    /*
     Create a date components to represent the number of days to subtract from the current date.
     The weekday value for Sunday in the Gregorian calendar is 1, so subtract 1 from the number of days to subtract from the date in question.  (If today is Sunday, subtract 0 days.)
     */
    NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
    [componentsToSubtract setDay: 0 - ([weekdayComponents weekday] - 2)];
    
    NSDate *beginningOfWeek = [gregorian dateByAddingComponents:componentsToSubtract toDate:date options:0];
    
    /*
     Optional step:
     beginningOfWeek now has the same hour, minute, and second as the original date (today).
     To normalize to midnight, extract the year, month, and day components and create a new date from those components.
     */
    
    NSDateComponents *components = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate: beginningOfWeek];
    beginningOfWeek = [gregorian dateFromComponents:components];
    
    NSLog(@"%@", beginningOfWeek);
    
    return beginningOfWeek;

}

-(NSDate *)nextFridayFromDate:(NSDate *)date {
    //NSDate *today = [[NSDate alloc] init];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    // Get the weekday component of the current date
    NSDateComponents *weekdayComponents = [gregorian components:NSWeekdayCalendarUnit fromDate:date];
    
    /*
     Create a date components to represent the number of days to subtract from the current date.
     The weekday value for Sunday in the Gregorian calendar is 1, so subtract 1 from the number of days to subtract from the date in question.  (If today is Sunday, subtract 0 days.)
     */
    NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
    [componentsToSubtract setDay: 0 + (6 - [weekdayComponents weekday])];
    
    NSDate *beginningOfWeek = [gregorian dateByAddingComponents:componentsToSubtract toDate:date options:0];
    
    /*
     Optional step:
     beginningOfWeek now has the same hour, minute, and second as the original date (today).
     To normalize to midnight, extract the year, month, and day components and create a new date from those components.
     */
    
    NSDateComponents *components = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate: beginningOfWeek];
    beginningOfWeek = [gregorian dateFromComponents:components];
    
    NSLog(@"%@", beginningOfWeek);
    
    return beginningOfWeek;
    
}


@end
