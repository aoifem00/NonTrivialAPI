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
@synthesize geocoder;


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
UIAlertView *errorAlert = [[UIAlertView alloc]
                           initWithTitle:@"Error"
                                 message:@"Failed to Get Your Location"
                                delegate:nil
                       cancelButtonTitle:@"OK"
                      otherButtonTitles:nil];
[errorAlert show];
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
    for(int i=2; i<7; i++){
        NSMutableArray *temp=[[NSMutableArray alloc]init];
        for(int j=1; j<5; j++){
            [temp addObject:daysAndTimes[j][i]];
        }
        [lots addObject:temp];
    }
    
    return lots;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSMutableArray* arr=[self setupArray];
    NSMutableArray* days=@[@"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday"];
    
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
    NSLog(@"%d", self.locationManager.authorizationStatus);
    [self.locationManager requestLocation];
    NSLog(@"%@", self.locationManager.location);
    //manager.delegate=self;
    //[self getLocation];
}
/*
- (void) getLocation{
    self.manager=[[CLLocationManager alloc] init];
    _manager.delegate=self;
    _manager.desiredAccuracy=kCLLocationAccuracyBest;
    [_manager startUpdatingLocation];
    
}*/

/*
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSLog(@"%@", [locations lastObject]);
}*/

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

- (IBAction) startTrip:(id)sender{
    CGRect mapFrame=CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.height-100);
    MKMapView* map=[[MKMapView alloc] initWithFrame:mapFrame];
    map.mapType=MKMapTypeHybrid;
    map.showsUserLocation=YES;
    map.userTrackingMode=MKUserTrackingModeFollow;
    //map.delegate=self;
    //[map setCenterCoordinate:coord];
   // map.showsUserLocation=YES;
    //map.userTrackingMode=MKUserTrackingModeFollow;
    //[map showU]
    [self.view addSubview:map];
    
}
@end
