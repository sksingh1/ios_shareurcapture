//
//  PriviewController.m
//  SampleApp
//
//  Created by INNOISDF700278 on 8/18/17.
//  Copyright © 2017 INNOISDF700278. All rights reserved.
//

#import "PriviewController.h"
#import "Entity+CoreDataProperties.h"
#import <AssetsLibrary/AssetsLibrary.h>
typedef void (^ALAssetsLibraryAssetForURLResultBlock)(ALAsset *asset);
typedef void (^ALAssetsLibraryAccessFailureBlock)(NSError *error);
@interface PriviewController ()

@end

@implementation PriviewController
- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

@synthesize setstr,captureImageview,ImagePickerController,locationlabel,locationbutton,msgtext,address,captureImage,fetcharray;

- (void)viewDidLoad {
    [super viewDidLoad];
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    NSLog(@"str %@",setstr);
    self.msgtext.delegate=self;
    self.msgtext.text = @"Write your thoughts...";
    self.msgtext.textColor = [UIColor lightGrayColor]; //optional
    self.locationlabel.text =self.address;
    [self.msgtext setReturnKeyType:UIReturnKeyDone];
    [self fetchdata];
    //self.captureImageview.image=captureImage;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    if(captureImage != nil){
    self.captureImageview.image=captureImage;
    }
}

#pragma mark - Navigation

 //In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"second controller");
     //Get the new view controller using [segue destinationViewController].
     //Pass the selected object to the new view controller.
}
-(IBAction)locationbuttonaction:(id)sender{
    UIAlertController * alert=[UIAlertController
                               
                               alertControllerWithTitle:@"" message:@"Do you want to change your current location!"preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"Yes, please"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action)
                                {
                                    [self okButtonPressed];
                                    
                                }];
    UIAlertAction* noButton = [UIAlertAction
                               actionWithTitle:@"No, thanks"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action)
                               {
                                   [self cancelButtonPressed];
                                   
                               }];
    
    [alert addAction:yesButton];
    [alert addAction:noButton];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    
    

}
-(IBAction)SubmitAction:(id)sender{
//    Entity* item = [NSEntityDescription insertNewObjectForEntityForName:@"Entity"
//                                                   inManagedObjectContext:_appDelegate.managedObjectContext];
//    item.location =self.locationlabel.text;
//    item.comments = self.msgtext.text;
    NSData *imageData = UIImagePNGRepresentation(self.captureImage);
    //item.image = imageData;
    NSManagedObjectContext *context = [self managedObjectContext];
    NSManagedObject *newDevice = [NSEntityDescription insertNewObjectForEntityForName:@"Entity" inManagedObjectContext:context];
    [newDevice setValue:self.locationlabel.text forKey:@"location"];
    [newDevice setValue:self.msgtext.text forKey:@"comments"];
    [newDevice setValue:imageData forKey:@"image"];
    [newDevice setValue:self.title forKey:@"categaryoption"];


    NSError *error = nil;
    // Save the object to persistent store
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }else{
        UIAlertController * alert=[UIAlertController
                                   
                                   alertControllerWithTitle:@"" message:@"Successfully submitted!"preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"Okay"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action)
                                    { }];
        [alert addAction:yesButton];
        [self presentViewController:alert animated:YES completion:nil];
        NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Entity"];
        self.fetcharray = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];

    }
    
    
    
    //NSLog(@"array is ====>>>> %@", self.fetcharray); //

}
-(IBAction)HistoryAction:(id)sender{
    if(fetcharray.count >0 ){
    }else{
        UIAlertController * alert=[UIAlertController
                                   
                                   alertControllerWithTitle:@"" message:@"No history available!"preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"Okay"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action)
                                    {
                                        //[self.navigationController popViewControllerAnimated:YES];
                                        
                                    }];
        
        
        [alert addAction:yesButton];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)fetchdata{

    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Entity"];
    fetcharray = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
}
- (void)cancelButtonPressed{
    // write your implementation for cancel button here.
}

- (void)okButtonPressed{
    [self.navigationController popViewControllerAnimated:YES];
    //write your implementation for ok button here
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"Write your thoughts..."]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor]; //optional
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"Write your thoughts...";
        textView.textColor = [UIColor lightGrayColor]; //optional
    }
    [textView resignFirstResponder];
}
- (BOOL)textView:(UITextView *)txtView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if( [text rangeOfCharacterFromSet:[NSCharacterSet newlineCharacterSet]].location == NSNotFound ) {
        return YES;
    }
    
    [txtView resignFirstResponder];
    return NO;
}
-(IBAction)selectphotoOption:(id)sender{
    UIAlertController * alert=[UIAlertController
                               
                               alertControllerWithTitle:@"" message:@"Select any photo source!"preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* CameraButton = [UIAlertAction
                                actionWithTitle:@"Camera"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action)
                                {
                                    [self selectCamera];
                                    
                                }];
    UIAlertAction* GalleryButton = [UIAlertAction
                                actionWithTitle:@"Gallery"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action)
                                {
                                    [self selectGallery];
                                    
                                }];
    UIAlertAction* CancelButton = [UIAlertAction
                                actionWithTitle:@"Cancel"
                                style:UIAlertActionStyleCancel
                                handler:^(UIAlertAction * action)
                                {
                                    //[self.navigationController popViewControllerAnimated:YES];
                                    
                                }];
    
    
    [alert addAction:CameraButton];
    [alert addAction:GalleryButton];
    [alert addAction:CancelButton];
    [self presentViewController:alert animated:YES completion:nil];
}
-(void)selectCamera{
    if (! [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"No Device" message:@"Camera is not available"preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
        
    } else {
        
        UIImagePickerController *cameraPicker = [[UIImagePickerController alloc] init];
        cameraPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        cameraPicker.delegate = _delegate;
        // Show image picker
        [self presentViewController:cameraPicker animated:YES completion:nil];
    }
    
}
-(void)selectGallery{
    self.ImagePickerController = [[UIImagePickerController alloc]init];
    self.ImagePickerController.delegate = self;
    self.ImagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentViewController:self.ImagePickerController animated:YES completion:nil];
    
    
}
#pragma mark - ImagePickerController Delegate

//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
//
//    NSLog(@"finish %@",info);
//    self.selectedimage = info[UIImagePickerControllerOriginalImage];
//    NSLog(@"finish");
//
//    //if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) {
//        [picker dismissViewControllerAnimated:YES completion:nil];
//
//    //self.selectedimage = [info objectForKey:UIImagePickerControllerOriginalImage];
//}
-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    NSLog(@"finish");
    //self.selectedimage = info[UIImagePickerControllerOriginalImage];
    
    //if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) {
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSURL *imageUrl  = (NSURL *)[info objectForKey:UIImagePickerControllerReferenceURL];
    NSLog(@"imageUrl %@",imageUrl);
    ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
    {
        ALAssetRepresentation *representation = [myasset defaultRepresentation];
        CGImageRef resolutionRef = [representation fullResolutionImage];
        
        if (resolutionRef) {
            UIImage *image = [UIImage imageWithCGImage:resolutionRef scale:1.0f orientation:(UIImageOrientation)representation.orientation];
            self.captureImage= image;
            self.captureImageview.image =image;
            
        }
    };
    ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
    {
        NSLog(@"cant get image - %@",[myerror localizedDescription]);
    };
    
    if(imageUrl)
    {
        ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc]init];
        [assetslibrary assetForURL:imageUrl resultBlock:resultblock failureBlock:failureblock];
    }
    
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
@end
