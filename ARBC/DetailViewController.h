//
//  DetailViewController.h
//  ARBC
//
//  Created by Árpád Kiss on 2014.05.08..
//  Copyright (c) 2014 OE-NIK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Book.h"
#import "UIImageView+AFNetworking.h"
#import "APIAgent.h"
#import "StorageManager.h"

@interface DetailViewController : UIViewController

@property (strong, nonatomic) Book *currentBook;
@property (nonatomic) BOOL hideButton;
@property (nonatomic, strong) NSManagedObjectContext *currentContext;

@end
