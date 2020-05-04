//
//  RPSController.m
//  RockPaperScissors
//
//  Created by Kuei-Jung Hu on 2020/5/5.
//  Copyright © 2020 Kuei-Jung Hu. All rights reserved.
//

#import "RPSController.h"
#import "RPSTurn.h"

@implementation RPSController

-(void)throwDown:(Move) playersMove {
    
    // Here the RPSTurn class generates the opponent's move
    RPSTurn *playersTurn = [[RPSTurn alloc] initWithMove:playersMove];
    RPSTurn *computersTurn = [[RPSTurn alloc] init];
    
//    computersTurn.move = playersTurn.move;
    
    // The RPSGame class stores the results of a game
    self.game = [[RPSGame alloc] initWithFirstTurn:playersTurn
                                        secondTurn:computersTurn];
    [self setGame:_game];
}

-(NSString*)messageForGame:(RPSGame*)game {
    // First, handle the tie
     if (game.firstTurn.move == game.secondTurn.move) {
         return @"It's a tie!";
     } else {
         // Then build up the results message "Rock defeats Scissors. You Win!" etc.
         NSString *winnerString = [[game winner] description];
         // Build the loserString here.
         NSString *loserString = [[game loser]  description];
         // Build the resultsString here.
         NSString *resultsString = [self resultString: game];
         
         // Combine the 3 strings using the NSString method, stringWithFormat:
         NSString *wholeString =  [NSString stringWithFormat:@"%@ %@ %@ %@ %@", winnerString, @" defeats ", loserString, @".",  resultsString];
         
         return wholeString;
     }
}

-(NSString*)resultString:(RPSGame*)game {
    return [game.firstTurn defeats:game.secondTurn] ? @"You Win!" : @"You Lose!";
}

@end
