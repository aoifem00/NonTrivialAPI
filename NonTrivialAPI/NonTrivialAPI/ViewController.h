//
//  ViewController.h
//  NonTrivialAPI
//
//  Created by Aoife McManus on 10/18/21.
//
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface ViewController : UIViewController<CLLocationManagerDelegate, MKMapViewDelegate> {
    //CLLocationManager *_manager;
}
@property(nonatomic, strong) CLLocationManager* locationManager;
@property(nonatomic, strong) MKMapView* map;
@property(nonatomic, strong) NSMutableDictionary *lotCoordinates;
@property(nonatomic, strong) NSArray* days;
@property(nonatomic, strong) NSMutableArray *times;
@property(nonatomic, strong) NSString* day;
@property(nonatomic, strong) NSArray *currLots;
@end


