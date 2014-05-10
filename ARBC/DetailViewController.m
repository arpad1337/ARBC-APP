//
//  DetailViewController.m
//  ARBC
//
//  Created by Árpád Kiss on 2014.05.08..
//  Copyright (c) 2014 OE-NIK. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *publisherLabel;
@property (weak, nonatomic) IBOutlet UIButton *addToFavouritesButton;


@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)configureView
{
    if(self.currentBook) {
        self.titleLabel.text = self.currentBook.title;
        self.authorLabel.text = self.currentBook.author;
        self.publisherLabel.text = self.currentBook.publisher;
        [self.coverImageView setImageWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@/%@", [APIAgent sharedAgent].apiURL, self.currentBook.cover]]];
    }
}

-(NSManagedObjectContext *)currentContext {
    if(_currentContext) {
        return _currentContext;
    } else {
        return [[StorageManager sharedManager] managedObjectContext];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
    if(self.hideButton) {
        self.addToFavouritesButton.alpha = 0;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onAddToFavourites:(id)sender {
    if(_currentContext != [[StorageManager sharedManager] managedObjectContext]) {
        [_currentContext save:nil];
    }
    [[self navigationController] popViewControllerAnimated:YES];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}

@end
