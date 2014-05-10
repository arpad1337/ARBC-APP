//
//  AddNewBookViewController.h
//  ARBC
//
//  Created by Árpád Kiss on 2014.05.09..
//  Copyright (c) 2014 OE-NIK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddNewBookViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    UIImagePickerController *_imgPicker;
}

@property (nonatomic, assign) id delegate;

@property (weak, nonatomic) IBOutlet UITextField *bookTitleTextField;
@property (weak, nonatomic) IBOutlet UITextField *bookAuthorTextField;
@property (weak, nonatomic) IBOutlet UITextField *bookPublisherTextField;
@property (weak, nonatomic) IBOutlet UITextField *bookKeywordsTextField;
@property (weak, nonatomic) IBOutlet UIImageView *bookCoverImageView;
@property (weak, nonatomic) IBOutlet UIButton *coverSelectButton;
@property (weak, nonatomic) IBOutlet UIButton *addNewBookButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@end

@protocol AddNewBookViewControllerDelegate
- (void)didFinishAddingFields:(NSDictionary *)fields;
- (void)addNewBookViewControllerDidCancel;
@end
