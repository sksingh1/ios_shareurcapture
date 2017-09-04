//
//  ViewController.h
//  SampleApp
//
//  Created by INNOISDF700278 on 8/11/17.
//  Copyright © 2017 INNOISDF700278. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>


@interface ViewController : UIViewController<MKMapViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
    IBOutlet MKMapView *mapView;
    IBOutlet UIButton *optionButton;
    IBOutlet UIButton *camButton;
    IBOutlet UIButton *galleryButton;
    IBOutlet UIButton *previewButton;
    NSString *selectedoption;
    
}
@property(nonatomic, assign) id<UINavigationControllerDelegate,UIImagePickerControllerDelegate> delegate;
@property(nonatomic, retain) UIImageView *selectedimage;
@property(nonatomic, retain) IBOutlet MKMapView *mapView;
@property(nonatomic, retain) CLLocationManager *locationManager;
@property(nonatomic, retain) UIImagePickerController *ImagePickerController;
@property(nonatomic, retain) NSString *selectedoption;
@property(nonatomic, retain) NSString *address;
@property(nonatomic, retain) MKPointAnnotation *point;
-(IBAction)selectOption:(id)sender;
-(IBAction)selectCamera:(id)sender;
-(IBAction)selectGallery:(id)sender;
-(IBAction)selectPreview:(id)sender;
@end

