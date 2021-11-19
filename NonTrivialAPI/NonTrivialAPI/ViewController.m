//
//  ViewController.m
//  NonTrivialAPI
//
//  Created by Aoife McManus on 10/18/21.
//

#import "ViewController.h"

@interface ViewController () <CLLocationManagerDelegate, MKMapViewDelegate>

@end

@implementation ViewController
@synthesize locationManager;
@synthesize map;



// Delegate method
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    NSLog(@"Hello");
    CLLocation* loc = [locations lastObject]; // locations is guaranteed to have at least one object
    float latitude = loc.coordinate.latitude;
    float longitude = loc.coordinate.longitude;
    NSLog(@"%.8f",latitude);
    NSLog(@"%.8f",longitude);
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    return;
}

- (NSString*) getDay{
    NSDate *date=[NSDate date];
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dateFormatter setLocalizedDateFormatFromTemplate:@"EEEE"];
    NSString* str=[dateFormatter stringFromDate:date];
    return str;
}

- (NSMutableArray*) setupArray{
    NSString *url_string=@"https://www.binghamton.edu/services/transportation-and-parking/parking/index.html";
    NSData *data = [NSData dataWithContentsOfURL: [NSURL URLWithString:url_string]];
    NSString * convertedStr =[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSRange range = [convertedStr rangeOfString : @"<tbody>"];
    int tableStart=(int)range.location;
    range=[convertedStr rangeOfString : @"</tbody>"];
    int tableEnd=(int)range.location;
    NSRange tableRange=NSMakeRange((NSUInteger)tableStart, (NSUInteger)tableEnd-tableStart);
    NSString *substr=[convertedStr substringWithRange:tableRange];
    
    //Separate elements by </td>
    NSMutableArray *listItems = (NSMutableArray*)[substr componentsSeparatedByString:@"</tr>"];
    NSMutableArray *daysAndTimes=[[NSMutableArray alloc] init];
    
    for(int i=0; i<listItems.count; i++){
        NSMutableArray *arr=(NSMutableArray*)[listItems[i] componentsSeparatedByString:@"<tr>"];
        if(arr.count==2){
            listItems[i]=arr[1];
        }
        [daysAndTimes addObject:[listItems[i] componentsSeparatedByString:@"<td>"]];
        
    }
    
    //Format 2d array
    for(int i=0; i<daysAndTimes.count; i++){
        for(int j=0; j<((NSMutableArray*)daysAndTimes[i]).count; j++){
            NSString* temp=(NSString*)daysAndTimes[i][j];
            if([temp containsString:@"</td>"]){
                NSArray* tempArr=[temp componentsSeparatedByString:@"</td>"];
                daysAndTimes[i][j]=tempArr[0];
            }
        }
    }
    
    //Finished final array lots for indexing by day and time
    
    
    NSMutableArray* lots=[[NSMutableArray alloc]init];
    int counter=0;
    for(int i=2; i<7; i++){
        NSMutableArray *temp=[[NSMutableArray alloc]init];
        for(int j=1; j<5; j++){
            counter++;
            [temp addObject:daysAndTimes[j][i]];
        }
        [lots addObject:temp];
    }
    NSLog(@"%@", lots);
    for(int i=0; i<counter; i++){
        NSArray* arr=[lots[i/4][i%4] componentsSeparatedByString:@", "];
        for(int j=0; j<arr.count; j++){
            //self.lotCoordinates[arr[j]]=@"Some value";
        }
    }
    //NSLog(@"%@", self.lotCoordinates);
    return lots;
}

- (void) addCoordinates{
   // CL
    //NSArray*arr=
    self.lotCoordinates=[[NSMutableDictionary alloc]init];
    self.lotCoordinates[@"E"]=@[@42.09184, @-75.96686];
    self.lotCoordinates[@"E1"]=@[@42.09273, @-75.96310];
    self.lotCoordinates[@"F"]=@[@42.09254, @-75.97190];
    self.lotCoordinates[@"F"]=@[@42.09257, @-75.97305];
    self.lotCoordinates[@"G1"]=@[@42.09277726615428, @-75.97072722220129];
    self.lotCoordinates[@"H"]=@[@42.09246554099309, @-75.97417006719479];
    self.lotCoordinates[@"M1"]=@[@42.085710373356704, @-75.97369199814878];
    self.lotCoordinates[@"M3"]=@[@42.087764235271834, @-75.97474889471316];
    /*F = "Some value";
    F3 = "Some value";
    G1 = "Some value";
    H = "Some value";
    M1 = "Some value";
    M3 = "Some value";
    M4 = "Some value";
    Y4 = "Some value";
    Y5 = "Some value";
    ZZ = "Some value";*/
    //self.lotCoordinates[]
    /*self.lotCoordinates[@"E1"]=CLLocationCoordinate2DMake(42.09273 -75.96310);*/
   // self.lotCoordinates[
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSMutableArray* arr=[self setupArray];
    
    NSArray* days=@[@"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday"];
    
    NSString *day=[self getDay];
    NSMutableArray* times;
    if([day isEqual:@"Saturday"]){
        day=@"Monday";
    }
    else if([day isEqual:@"Sunday"]){
        day=@"Monday";
    }
    int num=(int)[days indexOfObject:day];
    times=arr[num];
    [self homescreenView];
    self.locationManager=[[CLLocationManager alloc]init];
    self.locationManager.delegate=self;
    [self.locationManager requestAlwaysAuthorization];
    [self.locationManager requestWhenInUseAuthorization];
    
    self.locationManager.distanceFilter=kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy=kCLLocationAccuracyBest;
    
    [self.locationManager requestLocation];
}

- (void) homescreenView{
    NSString* str=@"Find a parking lot!";
    UILabel* label=[[UILabel alloc] init];
    label.text=str;
    label.textColor=UIColor.blackColor;
    CGFloat width=200;
    CGFloat height=50;
    CGFloat labelX=CGRectGetMidX(self.view.frame)-(width/2);
    CGFloat labelY=50;
    label.frame=CGRectMake(labelX, labelY, width, height);
    label.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    CGFloat buttonW=100;
    CGFloat buttonX=CGRectGetMidX(self.view.frame)-(buttonW/2);
    CGFloat buttonY=CGRectGetMidY(self.view.frame)-(height/2);
    UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(buttonX, buttonY, buttonW, height)];
    [button addTarget:self action:@selector(startTrip:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"Start trip" forState:UIControlStateNormal];
    [button setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [self.view addSubview:button];
    [button setBackgroundColor:UIColor.lightGrayColor];
}

- (void) addLotsToMap{
    NSArray* keys=[self.lotCoordinates allKeys];
    for(int i=0; i<keys.count; i++){
        NSArray *arr=[self.lotCoordinates objectForKey:keys[i]];
        double lat=[[arr objectAtIndex:0] doubleValue];
        double lon=[[arr objectAtIndex:1] doubleValue];
        MKPointAnnotation* point=[[MKPointAnnotation alloc]initWithCoordinate:CLLocationCoordinate2DMake(lat, lon)title:keys[i]subtitle:@""];
        [self.map addAnnotation:point];
    }
    
}
- (IBAction) startTrip:(id)sender{
    [self addCoordinates];
    
    CGRect mapFrame=CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.height-100);
    self.map=[[MKMapView alloc] initWithFrame:mapFrame];
    [self addLotsToMap];
    //[self.locationManager stopUpdatingLocation];
    //self.map.tintColor=UIColor.blueColor;
    //for(int i=0; i<self.)
    /*NSArray* arr=[self.lotCoordinates objectForKey:@"H"];
    NSLog(@"%@", arr);
    double lat=[[arr objectAtIndex:0] doubleValue];
    double lon=[[arr objectAtIndex:1] doubleValue];
    NSLog(@"%f", lat);
    MKPlacemark* placemark=[[MKPlacemark alloc]initWithCoordinate:CLLocationCoordinate2DMake(lat, lon)];
    [self.map addAnnotation:placemark];
    NSArray *a=self.map.annotations;
    NSLog(@"Annotations: %@", a);*/
   //double lon=(double)self.lotCoordinates[@"H1"][1];
    
    /*MKPointAnnotation* annotation=[[MKPointAnnotation alloc]initWithCoordinate:CLLocationCoordinate2DMake(self.lotCoordinates[@"H1"][0], self.lotCoordinates[@"H1"][1])];*/
    
    self.map.mapType=MKMapTypeHybrid;
    self.map.showsUserLocation=YES;
    self.map.userTrackingMode=MKUserTrackingModeFollow;
    
    //MKAnnotationView pin=
    
    //map.showsZoomControls=YES;
    //NSLog(@"%d", map.zoomEnabled);
    //map.delegate=self;
    //[map setCenterCoordinate:coord];
   // map.showsUserLocation=YES;
    //map.userTrackingMode=MKUserTrackingModeFollow;
    //[map showU]
    [self.view addSubview:map];
    
}
@end
