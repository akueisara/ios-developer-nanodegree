//
//  Person.m
//  Book
//
//  Created by Kuei-Jung Hu on 2020/5/5.
//  Copyright © 2020 Kuei-Jung Hu. All rights reserved.
//

#import "Person.h"

@implementation Person

-(instancetype)initWithName:(NSString*)name
                   birthday:(NSDate*)birthday {
    self = [super init];
    
    if(self) {
        _name = name;
        _birthday = birthday;
    }
    
    return self;
}

@end
