//
//  MasterViewController.m
//  ARBC
//
//  Created by Árpád Kiss on 2014.05.08..
//  Copyright (c) 2014 OE-NIK. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"

@implementation MasterViewController {
    NSArray* _books;
    NSFetchedResultsController* _fetchedResultsController;
    NSManagedObjectContext* _context;
    AddNewBookViewController* _anb;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(openAddBookView:)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    _context = [[StorageManager sharedManager] managedObjectContext];
    
    NSFetchRequest* fetchRequest = [Book MR_createFetchRequest];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]];
    
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:_context sectionNameKeyPath:nil cacheName:nil];
    
    _fetchedResultsController.delegate = self;
    [_fetchedResultsController performFetch:nil];

    [self fetchBooks];
    
    _anb = [[AddNewBookViewController alloc] initWithNibName:@"AddNewBookViewController" bundle:nil];
    _anb.delegate = self;
}

- (IBAction)openAddBookView:(id)sender {
    [self presentViewController:_anb animated:YES completion:nil];
}

#pragma mark addnewbook delegate

-(void)didFinishAddingFields:(NSDictionary *)fields {
    
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    

    _anb = [[AddNewBookViewController alloc] initWithNibName:@"AddNewBookViewController" bundle:nil];
    [[APIAgent sharedAgent] postToEndpoint:@"books"
                                withParams:@{
                                             @"author": [fields valueForKey:@"author"],
                                             @"title": [fields valueForKey:@"title"],
                                             @"keywords": [fields valueForKey:@"keywords"],
                                             @"publisher": [fields valueForKey:@"publisher"]
                                           }
                                 withImage:[fields valueForKey:@"cover"]
                                   andName:@"cover"
                                 onSuccess:^(id responseObject) {
                                     
                                     
                                     [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                                     

                                     NSLog(@"KOOLSÁG");
                                     NSDictionary *bookResponse = (NSDictionary *)responseObject;
                                     Book *book = [Book MR_createEntity];
                                     book.title = [bookResponse valueForKey:@"title"];
                                     book.cover = [bookResponse valueForKey:@"cover"];
                                     book.author = [bookResponse valueForKey:@"author"];
                                     book.publisher = [bookResponse valueForKey:@"publisher"];
                                     [[[StorageManager sharedManager] managedObjectContext] MR_saveOnlySelfAndWait];

                                     [self fetchBooks];
                                     [self.tableView reloadData];
                                     
    }
                                    onFail:^(NSError *error) {
        NSLog(@"ERRORR");
    }];
}

-(void)addNewBookViewControllerDidCancel {
    NSLog(@"canceled..");
}

-(void)fetchBooks {
    _books = [Book MR_findAllSortedBy:@"title" ascending:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_books count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell
          atIndexPath:(NSIndexPath *)indexPath {
    Book *book = _books[indexPath.row];
    cell.textLabel.text = book.title;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"whaaaat");
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_context deleteObject:[_fetchedResultsController objectAtIndexPath:indexPath]];
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Book *book = _books[indexPath.row];
        [[segue destinationViewController] setHideButton:YES];
        [[segue destinationViewController] setCurrentBook:book];
    }
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
        
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self fetchBooks];
    [self.tableView endUpdates];
}

@end
