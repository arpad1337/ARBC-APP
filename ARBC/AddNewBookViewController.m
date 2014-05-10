//
//  AddNewBookViewController.m
//  ARBC
//
//  Created by Árpád Kiss on 2014.05.09..
//  Copyright (c) 2014 OE-NIK. All rights reserved.
//

#import "AddNewBookViewController.h"

@interface AddNewBookViewController () <UITextFieldDelegate>

@end

@implementation AddNewBookViewController

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
    // Do any additional setup after loading the view from its nib.
    _imgPicker = [[UIImagePickerController alloc] init];
    _imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    _imgPicker.delegate = self;
    _imgPicker.allowsEditing = NO;
    
    _bookAuthorTextField.delegate = self;
    _bookPublisherTextField.delegate = self;
    _bookTitleTextField.delegate = self;
    _bookKeywordsTextField.delegate = self;

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

#pragma mark - UIImagePicker Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    if (info) {
        
        UIImage* outputImage = [info objectForKey:UIImagePickerControllerEditedImage];
        if (outputImage == nil) {
            outputImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        }
        
        if (outputImage) {
            self.bookCoverImageView.image = [self makeImage:outputImage];
            [_imgPicker dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

- (UIImage*)imageWithImage:(UIImage *)sourceImage scaledToWidth:(float) i_width
{
    float oldWidth = sourceImage.size.width;
    float scaleFactor = i_width / oldWidth;
    
    float newHeight = sourceImage.size.height * scaleFactor;
    float newWidth = oldWidth * scaleFactor;
    
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

-(UIImage *)makeImage:(UIImage *)image {
    UIImage *smallImage = [self imageWithImage:image scaledToWidth:640.0f]; //UIGraphicsGetImageFromCurrentImageContext();
    
    CGRect cropRect = CGRectMake(0, 0, 640, 800);
    CGImageRef imageRef = CGImageCreateWithImageInRect([smallImage CGImage], cropRect);
        
    UIImage *croppedImage = nil;
    // adjust image orientation
    switch ([[UIDevice currentDevice] orientation]) {
        case UIDeviceOrientationLandscapeLeft:
            croppedImage = [[UIImage alloc] initWithCGImage: imageRef
                                                       scale: 1.0
                                                 orientation: UIImageOrientationLeft];
            break;
        case UIDeviceOrientationLandscapeRight:
            croppedImage = [[UIImage alloc] initWithCGImage: imageRef
                                                       scale: 1.0
                                                 orientation: UIImageOrientationRight];
            break;
            
        case UIDeviceOrientationFaceUp:
            croppedImage = [[UIImage alloc] initWithCGImage: imageRef
                                                       scale: 1.0
                                                 orientation: UIImageOrientationUp];
            break;
            
        case UIDeviceOrientationPortraitUpsideDown:
            croppedImage = [[UIImage alloc] initWithCGImage: imageRef
                                                       scale: 1.0
                                                 orientation: UIImageOrientationDown];
            break;
            
        default:
            croppedImage = [UIImage imageWithCGImage:imageRef];
            break;
    }
    CGImageRelease(imageRef);

    return croppedImage;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSLog(@"FIRED");
    [textField resignFirstResponder];
    return NO;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [_imgPicker dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)onSelectCover:(id)sender {
    [self presentViewController:_imgPicker animated:YES completion:NULL];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onCancel:(id)sender {
    if ([_delegate respondsToSelector:@selector(addNewBookViewControllerDidCancel)]) {
        [_delegate addNewBookViewControllerDidCancel];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)onAdd:(id)sender {
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    [data setValue:_bookAuthorTextField.text forKey:@"author"];
    [data setValue:_bookTitleTextField.text forKey:@"title"];
    [data setValue:_bookPublisherTextField.text forKey:@"publisher"];
    [data setValue:_bookKeywordsTextField.text forKey:@"keywords"];
    [data setValue:_bookCoverImageView.image forKey:@"cover"];
    if([self validaFields:data]) {
        if ([_delegate respondsToSelector:@selector(didFinishAddingFields:)]) {
            [_delegate didFinishAddingFields:data];
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        NSLog(@"invalid");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hiba"
                                                        message:@"Kérjük ellenőrizze a beviteli mezők tartalmát."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (BOOL) validaFields:(NSDictionary *)data {
    if([data valueForKey:@"cover"] != nil &&
       [[data valueForKey:@"author"] length] > 0 &&
       [[data valueForKey:@"title"] length] > 0 &&
       [[data valueForKey:@"publisher"] length] > 0 ) {
        return YES;
    }
    return NO;
}

@end
