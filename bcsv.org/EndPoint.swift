//
//  EndPoint.swift
//  bcsv.org
//
//  Created by admin on 9/24/19.
//  Copyright © 2019 Haksoo Kim. All rights reserved.
//

import Foundation

class EndPoint123{
    
    enum endpoints {
        case SERMON_AUDIO
        case SERMON_YOUTUBE
        case BIBLE_TEXT
        case BIBLE_REVIEW
        case SERVING_TURN
        case BULLETIN
        case CONTACT
        case DAILY_BIBLE1
        case DAILY_BIBLE2
        case HOMEPAGE
        case ANNOUNCEMENT
    }
    
    static func getEndpoint(endpoint: endpoints) -> String{
        
        var myEndPoint: String?
        
        switch endpoint{
        case .SERMON_AUDIO:
            myEndPoint = "https://bcsv.org/sermon-mobile"
        case .SERMON_YOUTUBE:
            myEndPoint = "https://bcsv.org/youtube"
        case .BIBLE_TEXT:
            myEndPoint = "https://script.google.com/macros/s/AKfycbw7bStn4AKlbUsHc31YiEpuF2DXTxk9ExJZYHO9fM48ZJkHKTZ3/exec"
        case .BIBLE_REVIEW:
            myEndPoint = "https://script.google.com/macros/s/AKfycbw5zCwXjQNgoUXqco8El2D_vrtDUzGekIoUhaR0NRpdpSPGsmg/exec"
        case .SERVING_TURN:
            myEndPoint = "https://script.google.com/macros/s/AKfycbz_07Sy743osRJcaIaeIle58fAyCJ5Xz8HPYuTngb4spnqs8q-h/exec"
        case .BULLETIN:
            myEndPoint = "https://bcsv.org/bulletin-mobile"
        case .CONTACT:
            myEndPoint = "https://bcsv.org/contact"
        case .DAILY_BIBLE1:
            myEndPoint = "https://sum.su.or.kr:8888/Ajax/Bible/BodyBibleCont"
        case .DAILY_BIBLE2:
            myEndPoint = "https://sum.su.or.kr:8888/Ajax/Bible/BodyBible"
        case .HOMEPAGE:
            myEndPoint = "https://crane1129.wixsite.com/bcsv"
        case .ANNOUNCEMENT:
            myEndPoint = "https://script.google.com/macros/s/AKfycbxGDMGPV17xMbNtEjxNF7maU7vLB4rKV-ggE4lJULN55cxHx9o/exec"
        }
        
        return myEndPoint!
    }
}
