//
//  APIProvider.m
//  Weather
//
//  Created by Term Yad on 02.06.16.
//  Copyright © 2016 AntDavydov. All rights reserved.
//

#import "APIProvider.h"
#import "City.h"
#import "Favorite.h"
#define CURRENT_WEATHER_URL @"http://api.openweathermap.org/data/2.5/group?APPID=91e5b4b70c7cbcda35d78306273a5c61&units=metric&&lang=ru&"
#define CURRENT_WEATHER_ONE_URL @"http://api.openweathermap.org/data/2.5/weather?APPID=91e5b4b70c7cbcda35d78306273a5c61&units=metric&&lang=ru&"
#define FORECAST_URL @"http://api.openweathermap.org/data/2.5/forecast/?APPID=91e5b4b70c7cbcda35d78306273a5c61&units=metric&&lang=ru&id="

@implementation APIProvider

-(void) getCurrentWeatherForCity: (City *) city completion:(void(^)(NSInteger status, NSArray *data))completionBlock {
    
    NSString *requestText = [CURRENT_WEATHER_URL stringByAppendingString: [NSString stringWithFormat:@"id=%@", [NSString stringWithFormat:@"%ld,", [city.id integerValue]]]];
    
    [self getCurrentWeather:requestText completion:^(NSInteger status, NSArray *data) {
        if(status == 200) {
            completionBlock(status, [data copy]);
        } else {
            completionBlock(status, nil);
        }
    }];
}

-(void) getCurrentWeatherForCities: (NSArray *) cities completion:(void(^)(NSInteger status, NSArray *data))completionBlock {
    
    NSMutableString *requestIds = [NSMutableString string];
    for (Favorite *city in cities) {
        [requestIds appendString: [NSString stringWithFormat:@"%ld,", [city.cityId integerValue]]];
    }
    NSString *requestText = [CURRENT_WEATHER_URL stringByAppendingString: [NSString stringWithFormat:@"id=%@", requestIds]];
    
    
    [self getCurrentWeather:requestText completion:^(NSInteger status, NSArray *data) {
        if(status == 200) {
            completionBlock(status, data);
        } else {
            completionBlock(status, nil);
        }
    }];
}


-(void) getCurrentWeather: (NSString *) requestString completion:(void(^)(NSInteger status, NSArray *data))completionBlock {
    NSMutableArray *returnData = [[NSMutableArray alloc] init];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:requestString]];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                NSInteger status = 404;
                                                if (error == nil) {
                                                    status = [(NSHTTPURLResponse *)response statusCode];
                                                    if (status == 200) {
                                                        NSData *result = [NSJSONSerialization JSONObjectWithData:data
                                                                                                         options:kNilOptions
                                                                                                           error:nil];
                                                        
                                                        for (NSDictionary *item  in [result valueForKey:@"list"]) {
                                                            NSMutableDictionary *current =[[NSMutableDictionary alloc] init];
                                                            [current setValue:[[item valueForKey:@"main"] valueForKey:@"temp"] forKey:@"temp"];
                                                            [current setValue:[[item valueForKey:@"main"] valueForKey:@"temp_max"] forKey:@"temp_max"];
                                                            [current setValue:[[item valueForKey:@"main"] valueForKey:@"temp_min"] forKey:@"temp_min"];
                                                            [current setValue:[[item valueForKey:@"main"] valueForKey:@"humidity"] forKey:@"humidity"];
                                                            [current setValue:[[item valueForKey:@"main"] valueForKey:@"pressure"] forKey:@"pressure"];
                                                            [current setValue:[[item valueForKey:@"wind"] valueForKey:@"speed"] forKey:@"wind"];
                                                            [current setValue:[[[item valueForKey:@"weather"] valueForKey:@"description"] componentsJoinedByString:@""] forKey:@"descript"];
                                                            [current setValue:[[item valueForKey:@"weather"] valueForKey:@"icon"] forKey:@"icon"];
                                                            [current setValue:[item valueForKey:@"id"] forKey:@"cityId"];
                                                            [returnData addObject:current];
                                                            current = nil;
                                                        }
                                                        
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            completionBlock(status, [NSArray arrayWithArray:returnData]);
                                                        });
                                                    } else {
                                                        completionBlock(status, nil);
                                                    }
                                                    
                                                } else {
                                                    completionBlock(status, nil);
                                                }
                                            }];
    [task resume];
}

-(void) getForecastWeather: (NSInteger) city completion:(void(^)(NSInteger status, NSArray *data))completionBlock{
    NSMutableArray *returnData = [[NSMutableArray alloc] init];
    
    NSString *requestString = [FORECAST_URL stringByAppendingString:[NSString stringWithFormat:@"%ld,", (long)city]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:requestString]];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                NSInteger status = 404;
                                                if (error == nil) {
                                                    status = [(NSHTTPURLResponse *)response statusCode];
                                                    if (status == 200) {
                                                        NSData *result = [NSJSONSerialization JSONObjectWithData:data
                                                                                                         options:kNilOptions
                                                                                                           error:nil];
                                                        NSMutableArray *temp = [NSMutableArray array];
                                                        for (NSDictionary *item in [result valueForKey:@"list"]) {
                                                            
                                                                NSMutableDictionary *current =[[NSMutableDictionary alloc] init];
                                                                [current setValue:[[item valueForKey:@"main"] valueForKey:@"temp_max"] forKey:@"temp_max"];
                                                                [current setValue:[[[item valueForKey:@"weather"] valueForKey:@"description"] componentsJoinedByString:@""] forKey:@"descript"];
                                                                [current setValue:[[result valueForKey:@"city"] valueForKey:@"id"] forKey:@"cityId"];
                                                            
                                                            
                                                            [current setValue:[NSDate dateWithTimeIntervalSince1970:[[item valueForKey:@"dt"] doubleValue]] forKey:@"date"];
                                                                [temp addObject:current];
                                                                current = nil;
                                                        }
                                                        
                                                        for(int i = 1; i < [temp count]; i+=8) {
                                                            [returnData addObject:temp[i]];
                                                        }
                                                        temp = nil;
                                                        completionBlock(status, returnData);
                                                        
                                                    } else {
                                                        completionBlock(status, nil);
                                                    }
                                                    
                                                } else {
                                                    completionBlock(status, nil);
                                                }
                                            }];
    [task resume];
                                  
}

@end
