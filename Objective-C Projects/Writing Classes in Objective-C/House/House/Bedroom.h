//
//  Bedroom.h
//  House
//
//  Created by Kuei-Jung Hu on 2020/5/4.
//  Copyright © 2020 Kuei-Jung Hu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, Direction) {
    North,
    South,
    East,
    West
};

@interface Bedroom : NSObject

@property (nonatomic) BOOL privateBath;
@property (nonatomic) Direction directionWindowFaces;

@end

NS_ASSUME_NONNULL_END
