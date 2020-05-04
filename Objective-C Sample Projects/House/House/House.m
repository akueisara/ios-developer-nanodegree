//
//  House.m
//  House
//
//  Created by Kuei-Jung Hu on 2020/5/4.
//  Copyright © 2020 Kuei-Jung Hu. All rights reserved.
//

#import "House.h"

@interface House()
@property (nonatomic, readwrite) int numberOfBedrooms;
@end

@implementation House

-(instancetype)initWithAddress: (NSMutableString*) address {
    self = [super init];
    
    if(self) {
        _address = [address copy];
        _numberOfBedrooms = 3;
        _hasHotTub = false;
    }
    
    return self;
}

@end
