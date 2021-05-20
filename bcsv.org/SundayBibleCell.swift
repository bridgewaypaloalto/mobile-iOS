//
//  SundayBibleTableViewCell.swift
//  bcsv.org
//
//  Created by admin on 9/8/19.
//  Copyright © 2019 Haksoo Kim. All rights reserved.
//

import UIKit

class SundayBibleCell: UITableViewCell {

    @IBOutlet weak var sundayDateLbl: UILabel!
    @IBOutlet weak var sermonTitleLbl: UILabel!
    @IBOutlet weak var bibleTextLbl: UITextView!
    @IBOutlet weak var downloadLinkTextView: UITextView!
    var pinchGestureRecognizer : UIPinchGestureRecognizer!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(pinchGesture))
        self.bibleTextLbl.addGestureRecognizer(pinchGestureRecognizer)
        
        // Definition of double tap gesture
        let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        tap.numberOfTapsRequired = 2
        bibleTextLbl.addGestureRecognizer(tap)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func pinchGesture(gestureRecognizer: UIPinchGestureRecognizer ) {
        print("*** Pinch: Scale: \(gestureRecognizer.scale) Velocity: \(gestureRecognizer.velocity)")
        
        let font = self.bibleTextLbl.font
        var pointSize = font?.pointSize
        let fontName = font?.fontName
        
        pointSize = ((gestureRecognizer.velocity > 0) ? 1 : -1) * 1 + pointSize!;
        
        if (pointSize! < 13) { pointSize = 13}
        if (pointSize! > 42) { pointSize = 42}
            
        self.bibleTextLbl.font = UIFont(name: fontName!, size: pointSize!)
    }

    @objc func doubleTapped() {
        // do something here
         print("Double tapped detected.")
        if #available(iOS 9,*) {
            self.bibleTextLbl.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.regular);
        } else {
            self.bibleTextLbl.font = UIFont.systemFont(ofSize: 17);
        }
    }

    func setContent(sundayBible: SundayBible){
        
        if sundayBible.Title?.count ?? 0 > 0 {
            sundayDateLbl.text = "✝️" + String(sundayBible.Date ?? "None")
            sermonTitleLbl.text = sundayBible.Title
            
            //File Download URL
            if sundayBible.File_url?.count ?? 0 < 1{
                if #available(iOS 13.0, *) {
                    downloadLinkTextView.textColor = UIColor.link
                } else {
                    // Fallback on earlier versions
                    downloadLinkTextView.textColor = UIColor.blue
                }
                downloadLinkTextView.text = "File not available."
            }
            else{
                //file_downloadLbl.text = sundayBible.File_url
                downloadLinkTextView.isSelectable = true
                downloadLinkTextView.isEditable = false
                let text = "Download"
                let attributedString = NSAttributedString.makeHyperLink(for: sundayBible.File_url ?? "N/A", in: text, as: "Download")
                let font = downloadLinkTextView.font
                let alignment = downloadLinkTextView.textAlignment
                downloadLinkTextView.attributedText = attributedString
                downloadLinkTextView.font = font
                downloadLinkTextView.textAlignment = alignment
            }
        }
        
        let chapter: String? = "📖" + sundayBible.Bible_chapter! + "\n"
        let text: String? = sundayBible.Bible_text
        
        if chapter != nil{
            bibleTextLbl.text = chapter! + "\n" + text!
        }
    }
}

extension NSAttributedString {
    static func makeHyperLink2(for path: String, in string: String, as substring: String)->NSAttributedString{
        let nsString = NSString(string: string)
        let substringRange = nsString.range(of: substring)
        let attributedString = NSMutableAttributedString(string: string)
        attributedString.addAttribute(.link, value: path, range: substringRange)
        return attributedString
    }
}
