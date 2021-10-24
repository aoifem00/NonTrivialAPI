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
    NSError *error;
    NSString *url_string=@"https://www.binghamton.edu/services/transportation-and-parking/parking/index.html";
    NSData *data = [NSData dataWithContentsOfURL: [NSURL URLWithString:url_string]];
    NSLog(@"%@", data);

}


@end
