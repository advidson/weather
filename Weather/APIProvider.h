//
//  APIProvider.h
//  Weather
//
//  Created by Term Yad on 02.06.16.
//  Copyright © 2016 AntDavydov. All rights reserved.
//

#import <Foundation/Foundation.h>
@class City;
@class Favorite;

@interface APIProvider : NSObject

-(void) getCurrentWeatherForCity: (City *)city completion:(void(^)(NSInteger status, NSArray *data))completionBlock;
-(void) getCurrentWeatherForCities: (NSArray *) cities completion:(void(^)(NSInteger status, NSArray *data))completionBlock;
-(void) getForecastWeather: (NSInteger)city completion:(void(^)(NSInteger status, NSArray *data))completionBlock;
@end
