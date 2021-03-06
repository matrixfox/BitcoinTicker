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

@property (strong, nonatomic) IBOutlet UILabel *bsLastLabel;
@property (strong, nonatomic) IBOutlet UILabel *bsHighLabel;
@property (strong, nonatomic) IBOutlet UILabel *bsLowLabel;

@property (strong, nonatomic) IBOutlet UILabel *countdownLabel;

@end

@implementation ViewController
bool prerequisites;
int counter;
int coinBaseIndicator;
int bitstampIndicator;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    counter = 20;
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countdown) userInfo:nil repeats:YES];
    // Loads JSON data before counter
    [self coinBaseSpotPrice];
    [self coinBaseBuyPrice];
    [self coinBaseSellPrice];
    [self bitstampUSD];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self countIndicator];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)coinBaseSpotPrice{
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
             coinBaseIndicator++;
         }
     }];
}
-(void)coinBaseBuyPrice{
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
             coinBaseIndicator++;
         }
     }];
}
-(void)coinBaseSellPrice{
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
             coinBaseIndicator++;
         }
     }];
}

-(void)bitstampUSD{
    NSURL *url = [NSURL URLWithString:@"https://www.bitstamp.net/api/ticker/"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if (error == nil){
             NSDictionary *spotPrice = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
             // JSON Data
             self.bsLastLabel.text = [[spotPrice objectForKey:@"last"] stringByAppendingString:@" USD"];
             self.bsHighLabel.text = [[spotPrice objectForKey:@"high"] stringByAppendingString:@" USD"];
             self.bsLowLabel.text = [[spotPrice objectForKey:@"low"] stringByAppendingString:@" USD"];
         }
         bitstampIndicator++;
     }];
}


- (void)countIndicator {
    if ((coinBaseIndicator == 3) & (bitstampIndicator = 1)) {
        coinBaseIndicator = 0;
        bitstampIndicator = 0;
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
}

-(void)countdown{
    counter--;
    self.countdownLabel.text = [NSString stringWithFormat:@"%d", counter];
    if (counter == 0){
        counter = 20;
        [self coinBaseSpotPrice];
        [self coinBaseBuyPrice];
        [self coinBaseSellPrice];
        [self bitstampUSD];
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    }
    [self countIndicator];
}

@end
