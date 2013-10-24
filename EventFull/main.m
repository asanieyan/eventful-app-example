//
//  main.m
//  EventFull
//
//  Created by Arash  Sanieyan on 2013-10-19.
//  Copyright (c) 2013 GeekLab. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EFAppDelegate.h"

int main(int argc, char *argv[])
{
    @autoreleasepool {
        //prevent the test from running this 
        if ( NSClassFromString(@"SenTestCase") == nil ) {
           return UIApplicationMain(argc, argv, nil, NSStringFromClass([EFAppDelegate class]));
        } else {
           return UIApplicationMain(argc, argv, nil, @"EFTestAppDelegate");
        }
    }
}
