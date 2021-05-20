//
//  ServingTurnCell.swift
//  bcsv.org
//
//  Created by admin on 8/29/19.
//  Copyright © 2019 bcsv.org. All rights reserved.
//

import UIKit

class ServingTurnCell: UITableViewCell {
    
    @IBOutlet weak var sundayDateLbl: UILabel!
    @IBOutlet weak var prayDateLbl: UILabel!
    @IBOutlet weak var prayerNameLbl: UILabel!
    @IBOutlet weak var foodServerLbl: UILabel!
    @IBOutlet weak var babysitterLbl: UILabel!
    @IBOutlet weak var joycornerLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func getDate() -> String{
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        let formattedDate = format.string(from: date)
        
        return formattedDate
    }
    
    func setContent(servingTurn: ServingTurn){
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let today = dateFormatter.date(from: getDate())!
        let sundayDate = dateFormatter.date(from: servingTurn.date)!
        
        switch sundayDate.compare(today) {
        case .orderedAscending:
            print("Sunday has passed!")
        case .orderedDescending:
            print("It's future date")
            sundayDateLbl.text = "✝️주일 " + servingTurn.date
            prayerNameLbl.text = servingTurn.prayer
            foodServerLbl.text = servingTurn.food
            joycornerLbl.text = servingTurn.joycorner
            babysitterLbl.text = servingTurn.babysitter
            prayDateLbl.text = "(" + String(servingTurn.tuesday_pray_meeting.suffix(5)) + ")"
        case .orderedSame:
            print("Today is the day")
            sundayDateLbl.text = "✝️주일 " + servingTurn.date
            prayerNameLbl.text = servingTurn.prayer
            foodServerLbl.text = servingTurn.food
            joycornerLbl.text = servingTurn.joycorner
            babysitterLbl.text = servingTurn.babysitter
            prayDateLbl.text = "(" + String(servingTurn.tuesday_pray_meeting.suffix(5)) + ")"
        }
    }
}
