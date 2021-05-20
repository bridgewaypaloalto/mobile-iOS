//
//  ServingTurns.swift
//  bcsv.org
//
//  Created by admin on 8/30/19.
//  Copyright © 2019 Haksoo Kim. All rights reserved.
//

import UIKit

class ServingTurns: Codable{
    // The variable name should be same as the label name that containing the entire json payload in the return body.
    // This variable name is defined by the Google Script
    let servingTurns: [ServingTurn]
    
    init(servingTurns:[ServingTurn]){
        self.servingTurns = servingTurns
    }
}


class ServingTurn: Codable {
    
    let date: String
    let prayer: String
    let joycorner: String
    let food: String
    let tuesday_pray_meeting: String
    let babysitter: String
    
    init(date: String, prayer: String, joycorner: String, food: String, tuesday_pray_meeting: String, babysitter: String){
        self.date = date
        self.prayer = prayer
        self.joycorner = joycorner
        self.food = food
        self.tuesday_pray_meeting = tuesday_pray_meeting
        self.babysitter = babysitter
    }
}

