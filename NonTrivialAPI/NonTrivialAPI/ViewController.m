//
//  ViewController.m
//  NonTrivialAPI
//
//  Created by Aoife McManus on 10/18/21.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize manager;
@synthesize geocoder;

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
        //NSLog(@"%d", arr.count);
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
                //NSLog(@"%@", daysAndTimes[i][j]);
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
    NSLog(@"%@", lots);
    
    return lots;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSMutableArray* arr=[self setupArray];
    //NSMutableDictionary *dict=[self setupDictionary];
    //NSLog(@"%@", dict);
    NSMutableArray* days=@[@"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday"];
    
    NSString *day=[self getDay];
    NSLog(@"%@", day);
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
    
}

- (void) homescreenView{
    NSString* str=@"Find a parking lot!";
    UILabel* label=[[UILabel alloc] init];
    label.text=str;
    label.textColor=UIColor.blackColor;
    CGFloat width=200;
    CGFloat height=50;
    NSLog(@"%f", CGRectGetMidX(self.view.frame));
    CGFloat labelX=CGRectGetMidX(self.view.frame)-(width/2);
    //NSLog(@"%f", x);
    CGFloat labelY=50;
    label.frame=CGRectMake(labelX, labelY, width, height);
    label.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:label];
    for(int i=0; i<self.view.subviews.count; i++){
        NSLog(@"%@", self.view.subviews[i]);
    }
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
    //NSLog(@"Button clicked");
    
    CGRect mapFrame=CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.height-100);
    MKMapView* map=[[MKMapView alloc] initWithFrame:mapFrame];
    /*START*/
    map.showsUserLocation = YES;
    map.userTrackingMode=MKUserTrackingModeFollow;
    map.mapType = MKMapTypeHybrid;
    map.delegate = self;
    NSLog(@"%@", map);
    //NSLog(@"%@", map.userLocationVisible);
    //CLLocationManager* manager=[[CLLocationManager alloc] init];
    //[manager requestAlwaysAuthorization];
    
    //NSLog(@"%@", manager.authorizationStatus);
    /*END*/
    //NSLog(@"%@", map);
    [self.view addSubview:map];
    
}
@end
