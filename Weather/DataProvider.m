//
//  DataProvider.m
//  Weather
//
//  Created by Term Yad on 31.05.16.
//  Copyright © 2016 AntDavydov. All rights reserved.
//

#import "DataProvider.h"
#import "Reachability.h"

@interface DataProvider() {
    InternalDataManager *internal;
    APIProvider *api;
    BOOL isOnline;
    Reachability* internetReachable;
    Reachability* hostReachable;
}

@end

@implementation DataProvider

+(instancetype) sharedData {
    static DataProvider *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[DataProvider alloc] init];
    });
    return _sharedInstance;
}

-(instancetype) init {
    self = [super init];
    
    if(self) {
        internal = [[InternalDataManager alloc] init];
        api = [[APIProvider alloc] init];
        [self checkNetworkStatus];
    }
    
    return self;
}

-(NSArray *) citiesList {
    return [internal citiesList];
}

-(void) addCities: (NSArray *) cities {
    [internal addCities:cities];
}

-(NSArray *) searchCityByName: (NSString *) name {
    return [internal searchCityByName:name];
}

-(NSArray *) favoriteList {
    return [internal favoriteList];
}

-(NSArray *) favoriteById:(NSNumber *) cityId {
    return @[[internal favoriteCityById:cityId]];
}

-(void) addToFavorite: (City *) city {
    if ([internal addToFavorite: city]) {
        [self checkNetworkStatus];
        if (isOnline) {
        
            [api getCurrentWeatherForCity:city completion:^(NSInteger status, NSArray *data) {
                if(status == 200) {
                    [internal addCurentWeather: data];
                    [api getForecastWeather:[city.id integerValue] completion:^(NSInteger status, NSArray *data) {
                        if (status == 200) {
                            [internal addForecast:data];
                        }
                    }];
                }
            }];
        }
    }
    
}

-(void) removeFromFavorite: (Favorite *) city {
    [internal removeFromFavorite: (Favorite *) city];
}

- (void) moveItemAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex {
    [internal moveItemAtIndex:fromIndex toIndex:toIndex];
}

-(void) updateCurrentWeather:(NSArray *) cities {
    [self checkNetworkStatus];
    if (isOnline) {
        [api getCurrentWeatherForCities:cities completion:^(NSInteger status, NSArray *data) {
            if(status == 200) {
                [internal updateCurrentWeather: data];
            }
        }];
    }
}

-(void) forecastForCity:(Favorite *)city completion:(void(^)(NSInteger status, NSArray *data))completitionBlock {
    [self checkNetworkStatus];
    if (isOnline) {
        [api getForecastWeather:[city.cityId integerValue] completion:^(NSInteger status, NSArray *data) {
            if (status == 200) {
                [internal addForecast:data];
            }
            completitionBlock(status, data);
        }];
    }
    
}

-(void) checkNetworkStatus
{
    // called after network status changes
    internetReachable = [Reachability reachabilityForInternetConnection];
    NetworkStatus internetStatus = [internetReachable currentReachabilityStatus];
    switch (internetStatus)
    {
        case NotReachable:
        {
            NSLog(@"The internet is down.");
            isOnline = NO;
            
            break;
        }
        case ReachableViaWiFi:
        {
            NSLog(@"The internet is working via WIFI.");
            isOnline = YES;
            
            break;
        }
        case ReachableViaWWAN:
        {
            NSLog(@"The internet is working via WWAN.");
            isOnline = YES;
            
            break;
        }
    }
    
//    NetworkStatus hostStatus = [hostReachable currentReachabilityStatus];
//    switch (hostStatus)
//    {
//        case NotReachable:
//        {
//            NSLog(@"A gateway to the host server is down.");
//            isOnline = NO;
//            
//            break;
//        }
//        case ReachableViaWiFi:
//        {
//            NSLog(@"A gateway to the host server is working via WIFI.");
//            isOnline = YES;
//            
//            break;
//        }
//        case ReachableViaWWAN:
//        {
//            NSLog(@"A gateway to the host server is working via WWAN.");
//            isOnline = YES;
//            
//            break;
//        }
//    }
}

@end
