//
//  RPSGame.h
//  RockPaperScissors
//
//  Created by Kuei-Jung Hu on 2020/5/5.
//  Copyright © 2020 Kuei-Jung Hu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RPSTurn.h"

NS_ASSUME_NONNULL_BEGIN

@interface RPSGame : NSObject

@property (nonatomic) RPSTurn *firstTurn;
@property (nonatomic) RPSTurn *secondTurn;

-(instancetype)initWithFirstTurn:(RPSTurn*) firstTurn
                      secondTurn: (RPSTurn*) secondTurn;
-(RPSTurn*)winner;
-(RPSTurn*)loser;

@end

NS_ASSUME_NONNULL_END
