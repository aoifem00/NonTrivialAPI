//
//  ViewController.h
//  NonTrivialAPI
//
//  Created by Aoife McManus on 10/18/21.
//
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface ViewController : UIViewController
@property(nonatomic, strong) CLLocationManager* manager;
@property(nonatomic, strong) CLGeocoder* geocoder;

@end

