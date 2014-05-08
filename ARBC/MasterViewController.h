//
//  MasterViewController.h
//  ARBC
//
//  Created by Árpád Kiss on 2014.05.08..
//  Copyright (c) 2014 OE-NIK. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreData/CoreData.h>

@interface MasterViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
