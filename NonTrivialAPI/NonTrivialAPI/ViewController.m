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
    NSMutableArray *columns=[[NSMutableArray alloc] init];
    
    for(int i=0; i<listItems.count; i++){
        NSMutableArray *arr=(NSMutableArray*)[listItems[i] componentsSeparatedByString:@"<tr>"];
        //NSLog(@"%d", arr.count);
        if(arr.count==2){
            listItems[i]=arr[1];
        }
        [columns addObject:[listItems[i] componentsSeparatedByString:@"<td>"]];
        
    }
    NSDictionary *dict=[[NSDictionary alloc] init];
    NSArray *daysOfTheWeek=@[@"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday"];
    int currentDay=0;
    for(int i=0; i<columns.count; i++){
        for(int j=0; j<((NSArray*)columns[i]).count; j++){
            /*if(currentDay==5){
                continue;
            }
            if([columns[i][j] containsString:daysOfTheWeek[currentDay]]){
                NSLog(@"%@", columns[i][j]);
                columns[i][j]=
                currentDay=currentDay+1;
            }*/
           // NSLog(@"%@", columns[i][j]);
            NSString* temp=(NSString*)columns[i][j];
            if([temp containsString:@"</td>"]){
                NSArray* tempArr=[temp componentsSeparatedByString:@"</td>"];
                //NSLog(@"%d",[tempArr count]);
                columns[i][j]=tempArr[0];
                /*temp=[temp stringByReplacingOccurrencesOfString:@"</td>" withString:@""];
                NSLog(@"%@", temp);
                columns[i][j]=temp;*/
                
            }
            NSLog(@"%@", columns[i][j]);
        }
    }
    
    
}


@end
