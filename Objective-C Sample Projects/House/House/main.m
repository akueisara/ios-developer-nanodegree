//
//  main.m
//  House
//
//  Created by Kuei-Jung Hu on 2020/5/4.
//  Copyright © 2020 Kuei-Jung Hu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "House.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSMutableString *addressString = [[NSMutableString alloc] initWithString:@"555 Park Ave."];
        House *myHouse = [[House alloc] initWithAddress:addressString];
        NSLog(@"%@", myHouse.address);
        
        [addressString appendString:@"La la land"];
        NSLog(@"%@", myHouse.address);
        
        int number = myHouse.numberOfBedrooms;
        NSLog(@"%d", number);
    }
    return 0;
}
