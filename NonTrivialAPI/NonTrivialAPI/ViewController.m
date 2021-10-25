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
        NSArray *arr=[listItems[i] componentsSeparatedByString:@"<tr>"];
        //NSLog(@"%d", arr.count);
        if(arr.count==2){
            listItems[i]=arr[1];
        }
        [columns addObject:[listItems[i] componentsSeparatedByString:@"<td>"]];
        
    }
    for(int i=0; i<columns.count; i++){
        for(int j=0; j<((NSArray*)columns[i]).count; j++){
            NSLog(@"%@", columns[i][j]);
        }
    }
    
    
}


@end
