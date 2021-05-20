//
//  BibleReview.swift
//  bcsv.org
//
//  Created by admin on 9/21/19.
//  Copyright © 2019 Haksoo Kim. All rights reserved.
//

import Foundation

class BibleReviews: Codable{
    
    let sundayReview: [BibleReview]
    init (sundayReview:[BibleReview]){
        self.sundayReview = sundayReview
    }
}

class BibleReview: Codable{
    let date: String?
    let title: String?
    let chapter: String?
    var review: String?
    var application: String?
    var in_depth: String?
    
    init(date: String, title: String, chapter: String, review: String, application: String, in_depth: String){
        self.date = date
        self.title = title
        self.chapter = chapter
        self.review = review
        self.application = application
        self.in_depth = in_depth
    }
    
    func appendReview(review: String){
        self.review! += "\n\n➡" + review
    }
    
    func appendApplication(application: String){
        self.application! += "\n\n➡" + application
    }
    
    func appendInDepth(in_depth: String){
        self.in_depth! += "\n\n➡" + in_depth
    }
}


