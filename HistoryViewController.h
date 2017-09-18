//
//  HistoryViewController.h
//  SampleApp
//
//  Created by INNOISDF700278 on 8/30/17.
//  Copyright © 2017 INNOISDF700278. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "AppDelegate.h"
#import <CoreData/CoreData.h>
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
@interface HistoryViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
{
    UITableViewCell *cell;
    UIView* coverView;
}
@property(nonatomic, retain) IBOutlet UITableView *historytable;
@property(weak,nonatomic)AppDelegate *appDelegate;
@property (strong) NSMutableArray *fetcharray;
@property (nonatomic, retain) AVPlayerViewController *playerViewController;

@end
