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

- (void)getTimes:(NSMutableArray*)arr forDay:(int)currentDay{
    NSLog(@"%@", arr[currentDay]);
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //NSError *error;
    NSString *url_string=@"https://www.binghamton.edu/services/transportation-and-parking/parking/index.html";
    NSData *data = [NSData dataWithContentsOfURL: [NSURL URLWithString:url_string]];
    NSString * convertedStr =[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //NSLog(@"Converted String = %@",convertedStr);
    //NSMutableString* str=[NSMutableString alloc];
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
    NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];
    NSArray *daysOfTheWeek=@[@"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday"];
    //int currentDay=0;
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
    //Add days as keys in dictionary
    //Values will be another dictionary where the values in that dictionary are the parking lots
    //e.g. dict[@"Monday"]={[time 1]:parking lots, [time 2]: parking lots, etc.}
    int currDay=0;
    for(int i=0; i<=daysAndTimes.count; i++){
        NSString *temp=(NSString*)daysAndTimes[0][i];
        if([temp containsString:daysOfTheWeek[currDay]]){
            [dict setValue:@"placeholder" forKey:daysOfTheWeek[currDay]];
            currDay++;
        }
    }
    currDay=0;
    
    for(int i=0; i<daysAndTimes.count; i++){
        [self getTimes:daysAndTimes forDay:i];
        
    }
    //NSLog(@"%@", dict);
    
    
}


@end
