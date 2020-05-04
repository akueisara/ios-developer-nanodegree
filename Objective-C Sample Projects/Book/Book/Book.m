//
//  Book.m
//  Book
//
//  Created by Kuei-Jung Hu on 2020/5/5.
//  Copyright © 2020 Kuei-Jung Hu. All rights reserved.
//

#import "Book.h"
#import "Person.h"

@implementation Book

-(instancetype)initWithTitle:(NSString*)title
                      author:(Person*)author
                        year:(int)year {
    self = [super init];
    if(self) {
        _title = title;
        _author = author;
        _yearOfPublication = year;
    }

    return self;
}

@end
