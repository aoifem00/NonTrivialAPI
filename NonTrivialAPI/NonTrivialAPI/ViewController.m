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
@synthesize lotCoordinates;
@synthesize map;
@synthesize day;
@synthesize allLots;
@synthesize currLots;

typedef enum {
    Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday
} dayOfTheWeek;

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

- (NSNumber*) getDay{
    NSDate *date=[NSDate date];
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dateFormatter setLocalizedDateFormatFromTemplate:@"EEEE"];
    NSString* str=[dateFormatter stringFromDate:date];
    NSDictionary<NSString*, NSNumber*> *days=@{@"Monday": [NSNumber numberWithInt:Monday],
                                               @"Tuesday":[NSNumber numberWithInt:Tuesday],
                                               @"Wednesday":[NSNumber numberWithInt:Wednesday],
                                               @"Thursday":[NSNumber numberWithInt:Thursday],
                                               @"Friday":[NSNumber numberWithInt:Friday],
                                               @"Saturday":[NSNumber numberWithInt:Saturday],
                                               @"Sunday": [NSNumber numberWithInt:Sunday]};
    return days[str];
}

- (void) getAllLots{
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
    self.allLots=[[NSMutableArray alloc]init];
    int counter=0;
    for(int i=2; i<7; i++){
        NSMutableArray *temp=[[NSMutableArray alloc]init];
        for(int j=1; j<5; j++){
            counter++;
            [temp addObject:daysAndTimes[j][i]];
        }
        [self.allLots addObject:temp];
    }
}

- (void) addCoordinates{
    self.lotCoordinates=[[NSMutableDictionary alloc]init];
    self.lotCoordinates[@"E"]=@[@42.09184, @-75.96686];
    self.lotCoordinates[@"E1"]=@[@42.09273, @-75.96310];
    self.lotCoordinates[@"F"]=@[@42.09254, @-75.97190];
    self.lotCoordinates[@"G1"]=@[@42.09277726615428, @-75.97072722220129];
    self.lotCoordinates[@"H"]=@[@42.09246554099309, @-75.97417006719479];
    self.lotCoordinates[@"M1"]=@[@42.085710373356704, @-75.97369199814878];
    self.lotCoordinates[@"M3"]=@[@42.087764235271834, @-75.97474889471316];
    self.lotCoordinates[@"M4"]=@[@42.08912082270312, @-75.97522313614003];
    self.lotCoordinates[@"Y4"]=@[@42.084389420528495, @-75.9692225827033];
    self.lotCoordinates[@"Y5"]=@[@42.08420727286999, @-75.96860355942297];
    self.lotCoordinates[@"ZZ"]=@[@42.08696044639982, @-75.98075395148499];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getAllLots];
    
    self.day=[self getDay];
    
    if(day==[NSNumber numberWithInt:Sunday]){
        self.day=[NSNumber numberWithInt:Monday];
    }
    else if(day==[NSNumber numberWithInt:Sunday]){
        self.day=[NSNumber numberWithInt:Monday];
    }
    
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

- (void) getCurrentLots{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"H"];
    NSString *timeString = [formatter stringFromDate:date];
    
    NSInteger currTime=[timeString intValue];
    int timeIndex;
    if(currTime>=8 && currTime<10){
        timeIndex=0;
    }
    else if(currTime>=10 && currTime<13){
        timeIndex=1;
    }
    else if(currTime>=13 && currTime<15){
        timeIndex=2;
    }
    else if(currTime>=15 && currTime<17){
        timeIndex=3;
    }
    else{
        timeIndex=0;
    }
    NSArray* lotsForDay=(NSArray*)self.allLots[[day intValue]];
    self.currLots=[lotsForDay[timeIndex] componentsSeparatedByString:@", "];
}

- (void) addLotsToMap{
    [self getCurrentLots];
    for(int i=0; i<self.currLots.count; i++){
        NSArray* arr=[self.lotCoordinates objectForKey:self.currLots[i]];
        double lat=[[arr objectAtIndex:0] doubleValue];
        double lon=[[arr objectAtIndex:1] doubleValue];
        MKPointAnnotation* point=[[MKPointAnnotation alloc]initWithCoordinate:CLLocationCoordinate2DMake(lat, lon)title:self.currLots[i] subtitle:@""];
        [self.map addAnnotation:point];
    }
}

- (IBAction) startTrip:(id)sender{
    [self addCoordinates];
    
    CGRect mapFrame=CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.height-100);
    self.map=[[MKMapView alloc] initWithFrame:mapFrame];
    [self addLotsToMap];
    
    self.map.mapType=MKMapTypeHybrid;
    self.map.showsUserLocation=YES;
    self.map.userTrackingMode=MKUserTrackingModeFollow;
    
    [self.view addSubview:self.map];
}
@end
