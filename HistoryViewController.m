//
//  HistoryViewController.m
//  SampleApp
//
//  Created by INNOISDF700278 on 8/30/17.
//  Copyright © 2017 INNOISDF700278. All rights reserved.
//

#import "HistoryViewController.h"
#import "Entity+CoreDataProperties.h"

@interface HistoryViewController ()

@end

@implementation HistoryViewController
- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

@synthesize historytable,fetcharray;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.historytable.delegate =self;
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Clear" style:UIBarButtonItemStylePlain target:self action:@selector(deleteAllObjects:)];
    self.navigationItem.rightBarButtonItem = anotherButton;
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Entity"];
    self.fetcharray = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    self.historytable.hidden = YES;
    if(self.fetcharray.count >0){
        [historytable reloadData];
        self.historytable.hidden = NO;
    }
    
    NSLog(@"array is ======%@", self.fetcharray);

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.fetcharray.count >0){
    return self.fetcharray.count;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Create the cell (based on prototype)
    //if(cell== nil){
    cell = [tableView dequeueReusableCellWithIdentifier:@"NewRowCell" forIndexPath:indexPath];
    UILabel *location = [cell viewWithTag:1];
    UILabel *comments = [cell viewWithTag:2];
    UIImageView *imageview = [cell viewWithTag:3];
    UILabel *catoption = [cell viewWithTag:4];
    Entity *obj = [self.fetcharray objectAtIndex:indexPath.row];
    comments.text =obj.comments;
    location.text =obj.location;
    catoption.text =obj.categaryoption;
    
    imageview.image =[UIImage imageWithData:obj.image];
    //}
    return cell;
}
- (void)deleteAllObjects: (NSString *) entityDescription  {
    entityDescription =@"Entity";
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityDescription inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *items = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    
    for (NSManagedObject *managedObject in items) {
        [managedObjectContext deleteObject:managedObject];
        NSLog(@"%@ object deleted",entityDescription);
    }
    if (![managedObjectContext save:&error]) {
        NSLog(@"Error deleting %@ - error:%@",entityDescription,error);
    }
    if(error == nil){
        self.fetcharray = nil;
        [historytable reloadData];
        UIAlertController * alert=[UIAlertController
                                   
                                   alertControllerWithTitle:@"" message:@"No history available!"preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"Okay"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action)
                                    {
                                        [self.navigationController popViewControllerAnimated:YES];
                                        
                                    }];
        
        
        [alert addAction:yesButton];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
