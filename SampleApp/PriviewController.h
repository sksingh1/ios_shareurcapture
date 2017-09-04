//
//  PriviewController.h
//  SampleApp
//
//  Created by INNOISDF700278 on 8/18/17.
//  Copyright © 2017 INNOISDF700278. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "AppDelegate.h"
#import <CoreData/CoreData.h>

@interface PriviewController : UIViewController<UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    NSString *str;
    UIImage *captureImage;
}
@property(nonatomic, assign) id<UINavigationControllerDelegate,UIImagePickerControllerDelegate> delegate;
@property(nonatomic, assign) IBOutlet UIImageView *captureImageview;
@property(nonatomic, retain) UIImagePickerController *ImagePickerController;
//@property(nonatomic, retain) UIImage *captureImage;
@property(nonatomic,strong) UIImage *captureImage;
@property(nonatomic, assign) IBOutlet UIButton *locationbutton;
@property(nonatomic, retain) IBOutlet UITextView *msgtext;
@property(nonatomic, retain) IBOutlet UILabel *locationlabel;
@property (nonatomic,retain) NSString *setstr;
@property (nonatomic,retain) NSString *address;
@property(weak,nonatomic)AppDelegate *appDelegate;
@property (strong) NSMutableArray *fetcharray;

-(IBAction)locationbuttonaction:(id)sender;
-(IBAction)SubmitAction:(id)sender;
-(IBAction)HistoryAction:(id)sender;
-(void)selectCamera;
-(void)selectGallery;
-(IBAction)selectphotoOption:(id)sender;
@end
