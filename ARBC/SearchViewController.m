//
//  SearchViewController.m
//  ARBC
//
//  Created by Árpád Kiss on 2014.05.08..
//  Copyright (c) 2014 OE-NIK. All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController () {
    YCameraViewController *_camController;
    Book *_detectedBook;
    NSString *_hint;
    NSManagedObjectContext *_ch;
}
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UILabel *helperLabel;

@end

@implementation SearchViewController

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
    // Do any additional setup after loading the view.
    _camController = [[YCameraViewController alloc] initWithNibName:@"YCameraViewController" bundle:nil];
    _camController.delegate=self;
    self.searchButton.alpha = 1.0;
    _hint = @"A kereséshez fozózzon le egy könyvborítót. Fontos, hogy a megvilágításra ügyeljen, szükség esetén használjon vakut.";
    _helperLabel.text = _hint;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)search:(id)sender {
    if(sender == self.searchButton) {
        [self presentViewController:_camController animated:YES completion:nil];
    }
}

- (void)didFinishPickingImage:(UIImage *)image{
    // Use image as per your need
    NSLog(@"Image: %@", image.description);
    
    _searchButton.alpha = 0;
    _helperLabel.text = @"Betöltés...";
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    [[APIAgent sharedAgent] postToEndpoint:@"books/recognize" withParams:nil withImage:image andName:@"picture" onSuccess:^(id responseObject) {
        
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        if([responseObject isEqual:[NSNull null]])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Nincs találat"
                                                            message:@"Kérjük próbálja újra."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            
            _searchButton.alpha = 1.0;
            _helperLabel.text = _hint;

        } else {
        
            _searchButton.alpha = 1.0;
            _helperLabel.text = _hint;
        
            _ch = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
            _ch.parentContext = [[StorageManager sharedManager] managedObjectContext];

            NSDictionary *bookResponse = (NSDictionary *)responseObject;
            _detectedBook = [Book MR_createInContext:_ch];
            _detectedBook.title = [bookResponse valueForKey:@"title"];
            _detectedBook.cover = [bookResponse valueForKey:@"cover"];
            _detectedBook.author = [bookResponse valueForKey:@"author"];
            _detectedBook.publisher = [bookResponse valueForKey:@"publisher"];
        
            [self performSegueWithIdentifier:@"showScannedBookDetail" sender: self];
        }
        
    } onFail:^(NSError *error) {
        NSLog(@"Fail...");
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

        _searchButton.alpha = 1.0;
        _helperLabel.text = _hint;
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hiba"
                                                        message:@"Valami hiba lépett fel az azonosítás során, kérjük próbálja újra!"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }];
}

- (void)yCameraControllerDidCancel{
    // Called when user clicks on "X" button to close YCameraViewController
    NSLog(@"Canceled...");
}

- (void)yCameraControllerdidSkipped {
    NSLog(@"WTF");
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showScannedBookDetail"]) {
        [[segue destinationViewController] setCurrentContext:_ch];
        [[segue destinationViewController] setCurrentBook:_detectedBook];
    }
}


@end
