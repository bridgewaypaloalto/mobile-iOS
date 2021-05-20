//
//  AnnouncementCell.swift
//  bcsv.org
//
//  Created by Haksoo on 11/19/19.
//  Copyright © 2019 Haksoo Kim. All rights reserved.
//

import UIKit

class AnnouncementCell: UITableViewCell {

    @IBOutlet weak var Label_Date: UILabel!
    @IBOutlet weak var Label_Preacher: UILabel!
    @IBOutlet weak var TV_Announcement: UITextView!
    @IBOutlet weak var Label_Offering: UILabel!
    @IBOutlet weak var Label_TuesadyBabysitter: UILabel!
    @IBOutlet weak var TV_Download: UITextView!
    @IBOutlet weak var Label_Prayer: UILabel!
    var pinchGestureRecognizer : UIPinchGestureRecognizer!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        // Initialization code
        pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(pinchGesture))
        self.TV_Announcement.addGestureRecognizer(pinchGestureRecognizer)
        
        // Definition of double tap gesture
        let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        tap.numberOfTapsRequired = 2
        TV_Announcement.addGestureRecognizer(tap)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func pinchGesture(gestureRecognizer: UIPinchGestureRecognizer ) {
        print("*** Pinch: Scale: \(gestureRecognizer.scale) Velocity: \(gestureRecognizer.velocity)")
        
        let font = self.TV_Announcement.font
        var pointSize = font?.pointSize
        let fontName = font?.fontName
        
        pointSize = ((gestureRecognizer.velocity > 0) ? 1 : -1) * 1 + pointSize!;
        
        if (pointSize! < 13) { pointSize = 13}
        if (pointSize! > 42) { pointSize = 42}
            
        self.TV_Announcement.font = UIFont(name: fontName!, size: pointSize!)
    }

    @objc func doubleTapped() {
        // do something here
         print("Double tapped detected.")
        if #available(iOS 9,*) {
            self.TV_Announcement.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.regular);
        } else {
            self.TV_Announcement.font = UIFont.systemFont(ofSize: 17);
        }
    }
    
    func getDate() -> String{
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        let formattedDate = format.string(from: date)
        
        return formattedDate
    }
    
    func setContent(announcement: Announcement){
        
        Label_Date.text = announcement.date
        Label_Preacher.text = announcement.preacher
        Label_Prayer.text = "기도: " + announcement.prayer
        let announce_text = "\n\n" + announcement.announcement
        TV_Announcement.text = announce_text
        //let convert_offering_to_string: Float? = announcement.offering
        
        if announcement.offering?.count ?? 0 < 1{
            Label_Offering.text =  "추후공고"
        }
        else{
            Label_Offering.text =  announcement.offering
        }
        
        Label_TuesadyBabysitter.text = announcement.babysitter
        //File Download URL
        if announcement.File_url?.count ?? 0 < 1{
            if #available(iOS 13.0, *) {
                TV_Download.textColor = UIColor.link
            } else {
                // Fallback on earlier versions
                TV_Download.textColor = UIColor.blue
            }
            TV_Download.text = "File not available."
        }
        else{
            //file_downloadLbl.text = sundayBible.File_url
            TV_Download.isSelectable = true
            TV_Download.isEditable = false
            let text = "Download"
            let attributedString = NSAttributedString.makeHyperLink(for: announcement.File_url ?? "N/A", in: text, as: "Download")
            let font = TV_Download.font
            let alignment = TV_Download.textAlignment
            TV_Download.attributedText = attributedString
            TV_Download.font = font
            TV_Download.textAlignment = alignment
        }
    }

}
