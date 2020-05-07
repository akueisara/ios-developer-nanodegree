//
//  Book.h
//  Book
//
//  Created by Kuei-Jung Hu on 2020/5/5.
//  Copyright © 2020 Kuei-Jung Hu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Person.h"

NS_ASSUME_NONNULL_BEGIN

@interface Book : NSObject

@property (nonatomic) NSString * _Nonnull title;
@property (nonatomic) Person * _Nonnull author;
@property (nonatomic) Person * _Nullable editor;
@property (nonatomic) int yearOfPublication;

-(instancetype)initWithTitle:(NSString* _Nonnull)title
                      author:(Person* _Nonnull)author
                        year:(int)year;

@end

NS_ASSUME_NONNULL_END
