//
//  ViewController.m
//  SampleApp
//
//  Created by INNOISDF700278 on 8/11/17.
//  Copyright © 2017 INNOISDF700278. All rights reserved.
//

#import "ViewController.h"
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#import "PriviewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>

typedef void (^ALAssetsLibraryAssetForURLResultBlock)(ALAsset *asset);
typedef void (^ALAssetsLibraryAccessFailureBlock)(NSError *error);
@interface ViewController ()

@end

@implementation ViewController
@synthesize selectedimage,mapView,locationManager,point,selectedoption,ImagePickerController,address;
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.selectedimage = [[UIImageView alloc] init];
    
    mapView.delegate = self;
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
#ifdef __IPHONE_8_0
    if(IS_OS_8_OR_LATER) {
        // Use one or the other, not both. Depending on what you put in info.plist
        [self.locationManager requestWhenInUseAuthorization];
        [self.locationManager requestAlwaysAuthorization];
    }
#endif
    [self.locationManager startUpdatingLocation];
    
    mapView.showsUserLocation = YES;
    [mapView setMapType:MKMapTypeStandard];
    [mapView setZoomEnabled:YES];
    [mapView setScrollEnabled:YES];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
    NSLog(@"%@", [self deviceLocation]);
    
    //View Area
    MKCoordinateRegion region = { { 0.0, 0.0 }, { 0.0, 0.0 } };
    region.center.latitude = self.locationManager.location.coordinate.latitude;
    region.center.longitude = self.locationManager.location.coordinate.longitude;
    region.span.longitudeDelta = 0.005f;
    region.span.longitudeDelta = 0.005f;
    [mapView setRegion:region animated:YES];
    
}

//- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
//{
//    CLLocationCoordinate2D myCoordinate;
//     myCoordinate.latitude = 28.535517;
//     myCoordinate.longitude = 77.391029;
//    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(myCoordinate, 800, 800);
//    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
//}
- (NSString *)deviceLocation {
    return [NSString stringWithFormat:@"latitude: %f longitude: %f", self.locationManager.location.coordinate.latitude, self.locationManager.location.coordinate.longitude];
}
- (NSString *)deviceLat {
    return [NSString stringWithFormat:@"%f", self.locationManager.location.coordinate.latitude];
}
- (NSString *)deviceLon {
    return [NSString stringWithFormat:@"%f", self.locationManager.location.coordinate.longitude];
}
- (NSString *)deviceAlt {
    return [NSString stringWithFormat:@"%f", self.locationManager.location.altitude];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//-(void)CurrentLocationIdentifier
//{
////Latitude: 28.535517
////Longitude: 77.391029
//    //---- For getting current gps location
//    locationManager = [CLLocationManager new];
//    locationManager.delegate = self;
//    locationManager.distanceFilter = kCLDistanceFilterNone;
//    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
//    [locationManager startUpdatingLocation];
//    //------
//}
//- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
//{
//    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800);
//    [self.temp setRegion:[self.temp regionThatFits:region] animated:YES];
//}
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
//    CLLocationCoordinate2D myCoordinate;
//    myCoordinate.latitude = 28.535517;
//    myCoordinate.longitude = 77.391029;
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800);
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
    
    // Add an annotatioz
     MKPointAnnotation *changelocation = [[MKPointAnnotation alloc] init];
    
    changelocation.coordinate = userLocation.coordinate;
    changelocation.title = @"Where am I?";
    changelocation.subtitle = @"I'm here!!!";
    
    [self.mapView addAnnotation:changelocation];
}
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id < MKAnnotation >)annotation
{
    MKPinAnnotationView *pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"ident"];
    pinView.draggable = YES;
    pinView.animatesDrop = YES;
    return pinView;
}
- (void)mapView:(MKMapView *)mapView
 annotationView:(MKAnnotationView *)annotationView
didChangeDragState:(MKAnnotationViewDragState)newState
   fromOldState:(MKAnnotationViewDragState)oldState
{
    if (newState == MKAnnotationViewDragStateEnding)
    {
//        CLLocationCoordinate2D myCoordinate;
//        myCoordinate.latitude = 28.635517;
//        myCoordinate.longitude = 77.391029;
//        annotationView.annotation.coordinate=myCoordinate;
        CLLocationCoordinate2D droppedAt = annotationView.annotation.coordinate;
        [annotationView.annotation setCoordinate:droppedAt];
        //if(DEBUG_MODE){
            NSLog(@"Pin dropped at %f,%f", droppedAt.latitude, droppedAt.longitude);
        //}
        [locationManager stopUpdatingLocation];
    }
    
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
//    CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
//    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error)
//     {
//       CLPlacemark *topresult = [placemarks objectAtIndex:0];
//       MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
//       annotation.coordinate = topresult.location.coordinate;
//       annotation.title = @"Hi";
//       annotation.subtitle = @"Hello";
//     
//       [self.temp addAnnotation:annotation];
//     }];
    /********/
    currentLocation = [locations objectAtIndex:0];
    [locationManager stopUpdatingLocation];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error)
     {
         NSString *CountryArea;
         if (!(error))
         {
             CLPlacemark *placemark = [placemarks objectAtIndex:0];
             NSLog(@"\nCurrent Location Detected\n");
             NSLog(@"placemark %@",placemark);
             NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
             NSString *Address = [[NSString alloc]initWithString:locatedAt];
             NSString *Area = [[NSString alloc]initWithString:placemark.locality];
             NSString *Country = [[NSString alloc]initWithString:placemark.country];
             CountryArea = [NSString stringWithFormat:@"%@, %@", Area,Country];
             NSLog(@"CountryArea-- %@",CountryArea);
             self.address=Address;
             NSLog(@"Address-- %@",self.address);

         }
         else
         {
             NSLog(@"Geocode failed with error %@", error);
             NSLog(@"\nCurrent Location Not Detected\n");
             //return;
             CountryArea = NULL;
         }
         /*---- For more results
          placemark.region);
          placemark.country);
          placemark.locality);
          placemark.name);
          placemark.ocean);
          placemark.postalCode);
          placemark.subLocality);
          placemark.location);
          ------*/
     }];
}
-(IBAction)selectOption:(id)sender{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Category"
                                                                   message:@"Select relatively one of below list!"
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
   // alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))

    UIAlertAction *button1 = [UIAlertAction actionWithTitle:@"Traffic" style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * action) {
                                                        //code to run once button is pressed
                                                       self.selectedoption=@"Traffic";
                                                    }];
    UIAlertAction *button2 = [UIAlertAction actionWithTitle:@"Pollution" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //code to run once button is pressed
        self.selectedoption=@"Pollution";
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel
                                                    handler:^(UIAlertAction * action) {
                                                        //code to run once button is pressed
                                                    }];
    
    [alert addAction:button1];
    [alert addAction:button2];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}
-(IBAction)selectCamera:(id)sender{
    if (! [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
      
      
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"No Device" message:@"Camera is not available"preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
        
    } else {
        
        UIImagePickerController *cameraPicker = [[UIImagePickerController alloc] init];
        cameraPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        CFStringRef mTypes[2] = { kUTTypeImage, kUTTypeMovie };
        CFArrayRef mTypesArray = CFArrayCreate(CFAllocatorGetDefault(), (const void**)mTypes, 2, &kCFTypeArrayCallBacks);
        cameraPicker.mediaTypes = (__bridge NSArray*)mTypesArray;
        CFRelease(mTypesArray);

        cameraPicker.delegate = _delegate;
        // Show image picker
        [self presentViewController:cameraPicker animated:YES completion:nil];
    }
    
}
-(IBAction)selectGallery:(id)sender{
    CFStringRef mTypes[2] = { kUTTypeImage, kUTTypeMovie };
    CFArrayRef mTypesArray = CFArrayCreate(CFAllocatorGetDefault(), (const void**)mTypes, 2, &kCFTypeArrayCallBacks);
    self.ImagePickerController = [[UIImagePickerController alloc]init];
    self.ImagePickerController.delegate = self;
    self.ImagePickerController.videoMaximumDuration = 120.0f;
    self.ImagePickerController.allowsEditing = YES;
    self.ImagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    self.ImagePickerController.mediaTypes = (__bridge NSArray*)mTypesArray;
    CFRelease(mTypesArray);

    [self presentViewController:self.ImagePickerController animated:YES completion:nil];

    
}
#pragma mark - ImagePickerController Delegate

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //NSLog(@"finish");
    //self.selectedimage = info[UIImagePickerControllerOriginalImage];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    if([info[UIImagePickerControllerMediaType] isEqualToString:(__bridge NSString *)(kUTTypeImage)])
    {
        
        NSURL *imageUrl  = (NSURL *)[info objectForKey:UIImagePickerControllerReferenceURL];
        //NSLog(@"imageUrl %@",imageUrl);
        ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
        {
            ALAssetRepresentation *representation = [myasset defaultRepresentation];
            CGImageRef resolutionRef = [representation fullResolutionImage];
            
            if (resolutionRef) {
                UIImage *image = [UIImage imageWithCGImage:resolutionRef scale:1.0f orientation:(UIImageOrientation)representation.orientation];
                self.selectedimage.image =image;
                
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
    }else{
         videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
        //NSLog(@"videoURL == %@  ",videoURL);
    }

}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
-(IBAction)selectPreview:(id)sender{
    
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //[segue destinationViewController];
    //NSLog(@"First controller");
    if ([segue.identifier isEqualToString:@"priviewSegue"]){
        //I use this if statement to check which segue I am performing, if I have multiple
        //segues from a single view controller
        
        PriviewController *linkedInViewController = segue.destinationViewController;
        linkedInViewController.title=self.selectedoption;
        linkedInViewController.address=self.address;
        linkedInViewController.setstr=@"yupppiiii";
        if(videoURL != nil){
            linkedInViewController.videodataselected =videoURL;
        }
        UIImage *image = self.selectedimage.image;
        linkedInViewController.captureImage  =image;
        
    }
//    if ([segue.destinationViewController respondsToSelector:@selector(setstr)]) {
//        [segue.destinationViewController performSelector:@selector(setstr:)
//                                              withObject:@"str"];
//    }
    //Get the new view controller using [segue destinationViewController].
    //Pass the selected object to the new view controller.
}

@end
