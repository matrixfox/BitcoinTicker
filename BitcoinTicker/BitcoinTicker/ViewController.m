//
//  ViewController.m
//  BitcoinTicker
//
//  Created by matrixfox on 11/4/14.
//  Copyright (c) 2014 matrixfox. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UILabel *cbSpotLabel;
@property (strong, nonatomic) IBOutlet UILabel *cbHighLabel;
@property (strong, nonatomic) IBOutlet UILabel *cbLowLabel;
@property (strong, nonatomic) IBOutlet UILabel *countdownLabel;

@end

@implementation ViewController
int counter;
bool testing;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    counter = 20;
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countdown) userInfo:nil repeats:YES];
    // Testing
    testing = NO;
    if (testing == NO){
        [self cbSpotPrice];
        [self cbBuyPrice];
        [self cbSellPrice];
        testing = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)cbSpotPrice{
    NSURL *url = [NSURL URLWithString:@"https://coinbase.com/api/v1/prices/spot_rate"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if (error == nil){
             NSDictionary *spotPrice = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
             // JSON Data Tags
             self.cbSpotLabel.text = [[[spotPrice objectForKey:@"amount"] stringByAppendingString:@" "]
                                       stringByAppendingString:[spotPrice objectForKey:@"currency"]];
         }
     }];
}
-(void)cbBuyPrice{
    NSURL *url = [NSURL URLWithString:@"https://coinbase.com/api/v1/prices/buy"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if (error == nil){
             NSDictionary *spotPrice = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
             // JSON Data Tags
             self.cbHighLabel.text = [[[spotPrice objectForKey:@"amount"] stringByAppendingString:@" "]
                                      stringByAppendingString:[spotPrice objectForKey:@"currency"]];
         }
     }];
}
-(void)cbSellPrice{
    NSURL *url = [NSURL URLWithString:@"https://coinbase.com/api/v1/prices/sell"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if (error == nil){
             NSDictionary *spotPrice = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
             // JSON Data Tags
             self.cbLowLabel.text = [[[spotPrice objectForKey:@"amount"] stringByAppendingString:@" "]
                                     stringByAppendingString:[spotPrice objectForKey:@"currency"]];
         }
     }];
}

-(void)countdown{
    counter--;
    self.countdownLabel.text = [NSString stringWithFormat:@"%d", counter];
    if(counter == 0){
        counter = 20;
        [self cbSpotPrice];
        [self cbBuyPrice];
        [self cbSellPrice];
    }
}

@end
