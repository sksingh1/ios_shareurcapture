//
//  HistoryViewController.m
//  SampleApp
//
//  Created by INNOISDF700278 on 8/30/17.
//  Copyright © 2017 INNOISDF700278. All rights reserved.
//

#import "HistoryViewController.h"
#import "Entity+CoreDataProperties.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/MobileCoreServices.h>

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
    if(obj.videourl != nil){
        NSString *filename=[NSString stringWithFormat:@"%ld%@",(long)indexPath.row,@"video.mp4"];
        NSString *filePath = [self documentsPathForFileName:filename];
        
        BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
        if(!fileExists) {
            [obj.videourl writeToFile:filePath atomically:YES];
        }
        
        // access video as URL
        NSURL *urlVideoFile =  [NSURL fileURLWithPath:filePath];
      AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:urlVideoFile options:nil];
      AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
      gen.appliesPreferredTrackTransform = YES;
      CMTime time = CMTimeMakeWithSeconds(0.0, 600);
      NSError *error = nil;
      CMTime actualTime;
      CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
      UIImage *thumb = [[UIImage alloc] initWithCGImage:image];
      imageview.image=thumb;
      CGImageRelease(image);
    }else{
    imageview.image =[UIImage imageWithData:obj.image];
    }
    //}
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Entity *obj = [self.fetcharray objectAtIndex:indexPath.row];
    if(obj.videourl != nil){
        NSString *filename=[NSString stringWithFormat:@"%ld%@",(long)indexPath.row,@"video.mp4"];
        [self playvideo:obj.videourl :filename];
    }else if(obj.image != nil){
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        coverView = [[UIView alloc] initWithFrame:screenRect];
        coverView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        
        UIImageView *single_view = [[UIImageView alloc]initWithFrame:CGRectMake(12, 75, self.view.frame.size.width - 25 , self.view.frame.size.height - 92)];
        single_view.image=[UIImage imageWithData:obj.image];;
        [single_view setMultipleTouchEnabled:YES];
        [single_view setUserInteractionEnabled:YES];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];

        UILabel *testLabel = [[UILabel alloc] initWithFrame:CGRectMake(352, 68, 20, 20)];
        testLabel.font =[UIFont boldSystemFontOfSize:16.0f];
        testLabel.textColor =[UIColor redColor];
        testLabel.text= @" X";
        [testLabel addGestureRecognizer:singleTap];
        [testLabel setMultipleTouchEnabled:YES];
        [testLabel setUserInteractionEnabled:YES];
        
        CAShapeLayer *circleLayer = [CAShapeLayer layer];
        circleLayer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 20, 20)].CGPath;
        circleLayer.fillColor = [UIColor clearColor].CGColor;
        circleLayer.strokeColor = [UIColor redColor].CGColor;
        circleLayer.lineWidth = 2;
        
        // Add it do your label's layer hierarchy
        
        [testLabel.layer addSublayer:circleLayer];
        
        [coverView addSubview:single_view];
        [coverView addSubview:testLabel];
        [self.view addSubview:coverView];
    }
}
- (void)singleTapGestureCaptured:(UITapGestureRecognizer *)gesture
{
    UIView *tappedView = [gesture.view hitTest:[gesture locationInView:gesture.view] withEvent:nil];
    NSLog(@"Touch event on view: %@",[tappedView class]);
    [coverView removeFromSuperview];
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
-(void)playvideo:(NSData *)path:(NSString *)filename{
    NSString *filePath = [self documentsPathForFileName:filename];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    if(!fileExists) {
        [path writeToFile:filePath atomically:YES];
    }
    // access video as URL
    NSURL *urlVideoFile =  [NSURL fileURLWithPath:filePath];
    _playerViewController = [[AVPlayerViewController alloc] init];
    _playerViewController.player = [AVPlayer playerWithURL:urlVideoFile];
    //_playerViewController.view.frame = self.view.bounds;
    _playerViewController.showsPlaybackControls = YES;
    [self presentViewController:_playerViewController animated:YES completion:nil];
    _playerViewController.view.frame = self.view.frame;
    [_playerViewController.player play];
}
- (NSString *)documentsPathForFileName:(NSString *)name
{
    NSArray *paths =     NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    
    return [documentsPath stringByAppendingPathComponent:name];
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
