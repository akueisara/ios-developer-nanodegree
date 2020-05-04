//
//  RPSGame.m
//  RockPaperScissors
//
//  Created by Kuei-Jung Hu on 2020/5/5.
//  Copyright © 2020 Kuei-Jung Hu. All rights reserved.
//

#import "RPSGame.h"

@implementation RPSGame

-(instancetype)initWithFirstTurn:(RPSTurn*) firstTurn
                      secondTurn: (RPSTurn*) secondTurn {
    self = [super init];
    
    if(self) {
        _firstTurn = firstTurn;
        _secondTurn = secondTurn;
    }
    
    return self;
}

-(RPSTurn*)winner {
    return [self.firstTurn defeats:self.secondTurn] ? self.firstTurn : self.secondTurn;
}

-(RPSTurn*)loser {
    return [self.firstTurn defeats:self.secondTurn] ? self.secondTurn : self.firstTurn;
}



@end
