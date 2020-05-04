//
//  RPSTurn.m
//  RockPaperScissors
//
//  Created by Kuei-Jung Hu on 2020/5/5.
//  Copyright © 2020 Kuei-Jung Hu. All rights reserved.
//

#import "RPSTurn.h"

@implementation RPSTurn

-(instancetype)initWithMove:(Move) move {

    self = [super init];

    if (self){
        _move = move;
    }

    return self;
}

-(instancetype)init {

    self = [super init];

    if (self){
        _move = [self generateMove];
    }

    return self;
}

-(Move)generateMove {
    NSUInteger randomNumber = arc4random_uniform(3);
    
    switch(randomNumber) {
        case 0:
            return Rock;
            break;
        case 1:
            return Paper;
            break;
        case 2:
            return Scissors;
            break;
        default:
            return Invalid;
            break;
    }
    
    // placeholder
    return Rock;
}

-(BOOL)defeats:(RPSTurn*) turn {
    if ((self.move == Paper && turn.move == Rock) ||
        (self.move == Scissors && turn.move == Paper) ||
        (self.move == Rock && turn.move == Scissors)) {
        return true;
    } else {
        return false;
    }
}

-(NSString*)description {
    switch(self.move) {
        case Rock :
            return @"Rock";
        case Paper:
            return @"Paper";
        case Scissors:
            return @"Scissors";
        case Invalid:
            return @"Invalid";
    }
}

@end
