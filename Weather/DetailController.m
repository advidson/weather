//
//  DetailController.m
//  Weather
//
//  Created by Term Yad on 31.05.16.
//  Copyright © 2016 AntDavydov. All rights reserved.
//

#import "DetailController.h"
#import "Current_weather.h"
#import "CurrentTable.h"
#import "ForecastTable.h"
#import "DataProvider.h"

@interface DetailController () <UIScrollViewDelegate> {

    ForecastTable *forecast;
}

@end

@implementation DetailController

-(void) loadView {
    CGRect rect = [[UIScreen mainScreen] bounds];
    rect.size.height = rect.size.height;
    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    scroll.contentSize = CGSizeMake(rect.size.width, rect.size.height);
    self.view = scroll;
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
    header.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin;
    header.backgroundColor = [UIColor greenColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, header.frame.size.width, 40)];
    label.text = [NSString stringWithFormat:@"Сейчас в %@ %@", self.headerTitle, self.city.current.descript ];
    label.textAlignment = NSTextAlignmentCenter;
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin;
    [header addSubview:label];
    [self.view addSubview:header];
    label = nil;
    header = nil;
    
    CurrentTable *current = [[CurrentTable alloc] initWithFrame:CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height/2) style:UITableViewStylePlain andData:self.city.current];
    header.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin;
    current.delegate = current;
    current.dataSource = current;
    current.alwaysBounceVertical = NO;
    [self.view addSubview:current];
    
    [super viewDidLoad];
    
    header = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height/2, self.view.frame.size.width, 60)];
    header.backgroundColor = [UIColor greenColor];
    label = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, header.frame.size.width, 40)];
    label.text = [NSString stringWithFormat:@"Прогноз на 5 дней"];
    label.textAlignment = NSTextAlignmentCenter;
    [header addSubview:label];
    [self.view addSubview:header];
    
    forecast = [[ForecastTable alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height/2 + 60, self.view.frame.size.width, self.view.frame.size.height/3)
                                              style:UITableViewStylePlain
                                            andData:(NSSet *)self.city.forecast];
    
    header.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin;
    forecast.delegate = forecast;
    forecast.dataSource = forecast;
    forecast.alwaysBounceVertical = NO;
    [self.view addSubview:forecast];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.headerTitle;
    
    UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activity.center = forecast.center;
    [activity startAnimating];
    [self.view addSubview:activity];
    [[DataProvider sharedData] forecastForCity:self.city completion:^(NSInteger status, NSArray *data) {
        if(status == 200) {
            
            Favorite *city = [[[DataProvider sharedData] favoriteById:self.city.cityId] firstObject];
            [forecast updateForecast:(NSSet *)city.forecast];
        }
    }];
    [activity stopAnimating];
    [activity removeFromSuperview];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
