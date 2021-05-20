//
//  AnnouncementModel.swift
//  bcsv.org
//
//  Created by Haksoo on 11/19/19.
//  Copyright © 2019 Haksoo Kim. All rights reserved.
//

import Foundation

class Announcements: Codable{
    // The variable name should be same as the label name that containing the entire json payload in the return body.
    // This variable name is defined by the Google Script
    let announcements: [Announcement]
    
    init(announcements:[Announcement]){
        self.announcements = announcements
    }
}


class Announcement: Codable {
    
    let date: String
    let prayer: String
    let announcement: String
    let preacher: String
    let tuesday_pray_meeting: String?
    let babysitter: String?
    let offering: String?
    let File_url: String?
    
    init(date: String,
         prayer: String,
         announcement: String,
         preacher: String,
         tuesday_pray_meeting: String,
         babysitter: String,
         offering: String,
         File_url: String)
    {
        self.date = date
        self.prayer = prayer
        self.announcement = announcement
        self.preacher = preacher
        self.tuesday_pray_meeting = tuesday_pray_meeting
        self.babysitter = babysitter
        self.offering = offering
        self.File_url = File_url
    }
}
