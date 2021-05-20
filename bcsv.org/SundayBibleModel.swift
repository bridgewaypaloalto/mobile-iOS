//
//  SundayBibleModel.swift
//  bcsv.org
//
//  Created by admin on 9/8/19.
//  Copyright © 2019 Haksoo Kim. All rights reserved.
//

import UIKit

class SundayBibles: Codable{
    // The variable name should be same as the label name that containing the entire json payload in the return body.
    // This variable name is defined by the Google Script
    let bibleText: [SundayBible]
    init (bibleText:[SundayBible]){
        self.bibleText = bibleText
    }
}

class SundayBible: Codable {
    
    let Date: String?
    let Title: String?
    let Bible_chapter: String?
    let File_url: String?
    var Bible_text: String?
    
    init(date: String, title: String, chapter: String, text: String, file_url: String){
        self.Date = date
        self.Title = title
        self.Bible_chapter = chapter
        self.File_url = file_url
        self.Bible_text = text
    }
    
    func appendBibleText(text: String){
        self.Bible_text! += "\n" + text
    }
}
