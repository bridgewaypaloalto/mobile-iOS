//
//  BibleStudyCell.swift
//  bcsv.org
//
//  Created by admin on 9/21/19.
//  Copyright © 2019 Haksoo Kim. All rights reserved.
//

import UIKit

class BibleReviewCell: UITableViewCell {
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    
    let chapter_Header: String = "✝️ 본문: "
    let review_Header: String = "🔖 본문복습 질문\n"
    let application_Header: String = "🔖 적용 질문\n"
    let in_depth_Header: String = "🔖 심화학습 질문\n"
    var pinchGestureRecognizer : UIPinchGestureRecognizer!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(pinchGesture))
        self.contentTextView.addGestureRecognizer(pinchGestureRecognizer)
        
        // Definition of double tap gesture
        let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        tap.numberOfTapsRequired = 2
        contentTextView.addGestureRecognizer(tap)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func pinchGesture(gestureRecognizer: UIPinchGestureRecognizer ) {
        print("*** Pinch: Scale: \(gestureRecognizer.scale) Velocity: \(gestureRecognizer.velocity)")
        
        let font = self.contentTextView.font
        var pointSize = font?.pointSize
        let fontName = font?.fontName
        
        pointSize = ((gestureRecognizer.velocity > 0) ? 1 : -1) * 1 + pointSize!;
        
        if (pointSize! < 13) { pointSize = 13}
        if (pointSize! > 42) { pointSize = 42}
            
        self.contentTextView.font = UIFont(name: fontName!, size: pointSize!)
    }
    
    @objc func doubleTapped() {
        // do something here
         print("Double tapped detected.")
        if #available(iOS 9,*) {
            self.contentTextView.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.regular);
        } else {
            self.contentTextView.font = UIFont.systemFont(ofSize: 17);
        }
    }
    
    func setContent(bibleReview: BibleReview){
        
        if !(bibleReview.title ?? "").isEmpty {
            dateLbl.text = "📝" + String(bibleReview.date ?? "None")
            titleLbl.text = bibleReview.title
            
            contentTextView.text = chapter_Header + String(bibleReview.chapter ?? "N/A") + "\n\n"
            contentTextView.text += review_Header + String(bibleReview.review ?? "N/A") + "\n\n"
            contentTextView.text += application_Header + String(bibleReview.application ?? "N/A") + "\n\n"
            contentTextView.text += in_depth_Header + String(bibleReview.in_depth ?? "N/A") + "\n\n"
        }
    }
}
