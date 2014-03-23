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
    

    
    UIButton *selectPicture = [[UIButton alloc] initWithFrame:CGRectMake(0, 100, 320, 360)];
    [selectPicture setTitle:@"Choose from library" forState:UIControlStateNormal];
    [selectPicture setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [selectPicture addTarget:self action:@selector(selectPicture:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:selectPicture];

    
    UIButton *takePicture = [[UIButton alloc] initWithFrame:CGRectMake(0, 100, 320, 60)];
    takePicture.backgroundColor = [UIColor redColor];
    [takePicture setTitle:@"Take a Picture" forState:UIControlStateNormal];
    [takePicture setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
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
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)editingInfo {
    
    UIImage *image = editingInfo[UIImagePickerControllerEditedImage];
    
    NSURL *url = [editingInfo objectForKey:@"UIImagePickerControllerReferenceURL"];
    
    if (url == nil) {
        
        
        NSDictionary *metadata = [editingInfo objectForKey:UIImagePickerControllerMediaMetadata];
        NSDictionary *exifMetadata = [metadata objectForKey:(id)kCGImagePropertyExifDictionary];
        NSString *pictureDate = [exifMetadata objectForKey:@"DateTimeOriginal"];
        
        
        // Convert string to date object
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy:MM:d HH:mm:ss"];
        NSDate *date = [dateFormat dateFromString:pictureDate];
        
        NSLog(@"Picture taken: %@", date);
        
        NSDate *nextMonday = [self previousMondayFromDate:date];
        NSDate *nextFriday = [self nextFridayFromDate:date];
        
        NSDateFormatter *prettyDate = [[NSDateFormatter alloc] init];
        [prettyDate setDateFormat:@"LLLL d"];
        
        NSString *folderName = [@"Receipt - " stringByAppendingString:[[[prettyDate stringFromDate:nextMonday] stringByAppendingString:@" - "] stringByAppendingString:[prettyDate stringFromDate:nextFriday]]];
        
        NSLog(@"FOLDER NAME: %@", folderName);
        
        [self.library saveImage:image toAlbum:folderName completion:nil failure:nil];
        
    } else {
        NSLog(@"HELLO WORLD");
        
        
        
        [self.library assetForURL:url resultBlock:^(ALAsset *asset) {
            NSDate *date = [asset valueForProperty:ALAssetPropertyDate];
 
            NSDate *nextMonday = [self previousMondayFromDate:date];
            NSDate *nextFriday = [self nextFridayFromDate:date];
            
            NSDateFormatter *prettyDate = [[NSDateFormatter alloc] init];
            [prettyDate setDateFormat:@"LLLL d"];
            
            NSString *folderName = [@"Receipt - " stringByAppendingString:[[[prettyDate stringFromDate:nextMonday] stringByAppendingString:@" - "] stringByAppendingString:[prettyDate stringFromDate:nextFriday]]];
            
            NSLog(@"FOLDER NAME: %@", folderName);
            
            [self.library saveImage:image toAlbum:folderName completion:nil failure:nil];
            
        } failureBlock:^(NSError *error) {
            NSLog(@"Error");
        }];
        
        
        
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
