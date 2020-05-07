//
//  main.m
//  GuitarString
//
//  Created by Gabrielle Miller-Messner on 4/13/16.
//  Copyright © 2016 Gabrielle Miller-Messner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GuitarString-Swift.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        // a. Create an instance of the class GuitarString
         GuitarString *guitarString = [[GuitarString alloc] init];
        // b. Create an NSError
        NSError *error = nil;
        // c. Call the method pluck(velocity: Float)
        [guitarString pluck:1.0 error:&error];
        // d. Check if an error was returned
        // e. Log an error if one was returned
        if (error) {
            NSLog(@"%ld", (long)error.code);
            if (error.code == 876) {
                NSLog(@"Your string is broken");
            } else if (error.code == 543) {
                NSLog(@"Your string is out of tune");
            } else {
                NSLog(@"I don't know why your string doesn't sound");
            }
        }
    }
    return 0;
}
