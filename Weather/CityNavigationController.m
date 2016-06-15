//
//  CityNavigationController.m
//  Weather
//
//  Created by Term Yad on 31.05.16.
//  Copyright © 2016 AntDavydov. All rights reserved.
//

#import "CityNavigationController.h"

@interface CityNavigationController () {
    UIViewController *root;
}

@end

@implementation CityNavigationController

-(instancetype) init {
    self = [super init];
    if (self) {
        root = [[CityListController alloc] init];
        self.viewControllers = @[root];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
