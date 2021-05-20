//
//  EndpointsModel.swift
//  bcsv.org
//
//  Created by Haksoo on 3/10/20.
//  Copyright © 2020 Haksoo Kim. All rights reserved.
//

import Foundation

class WebEndpoints: Codable{
    // The variable name should be same as the label name that containing the entire json payload in the return body.
    // This variable name is defined by the Google Script
    let endpoints: [WebEndpoint]
    
    init(endpoints:[WebEndpoint]){
        self.endpoints = endpoints
    }
}


class WebEndpoint: Codable {
    
    let endpoint: String
    let url: String
    
    init(endpoint: String, url: String)
    {
        self.endpoint = endpoint
        self.url = url
    }
}

