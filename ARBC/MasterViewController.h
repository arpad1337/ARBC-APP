//
//  MasterViewController.h
//  ARBC
//
//  Created by Árpád Kiss on 2014.05.08..
//  Copyright (c) 2014 OE-NIK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Book.h"
#import "StorageManager.h"
#import "AddNewBookViewController.h"
#import "APIAgent.h"

@interface MasterViewController : UITableViewController <NSFetchedResultsControllerDelegate, AddNewBookViewControllerDelegate>

@end
