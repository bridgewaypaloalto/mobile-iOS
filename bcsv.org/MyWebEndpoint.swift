//
//  Endpoints.swift
//  bcsv.org
//
//  Created by Haksoo on 3/10/20.
//  Copyright © 2020 Haksoo Kim. All rights reserved.
//

import Foundation

class MyWebEndpoint{
    
    enum JSONError: String, Error {
        case NoData = "ERROR: no data"
        case ConversionFailed = "ERROR: conversion from JSON failed"
    }
    
    struct EndpointKey{
        static let ANNOUNCEMENT = "ANNOUNCEMENT"
        static let BIBLE_REVIEW = "BIBLE_REVIEW"
        static let BIBLE_TEXT = "BIBLE_TEXT"
        static let CONTACT = "CONTACT"
        static let DAILY_BIBLE1 = "DAILY_BIBLE1"
        static let DAILY_BIBLE2 = "DAILY_BIBLE2"
        static let HOMEPAGE = "HOMEPAGE"
        static let SERMON_AUDIO = "SERMON_AUDIO"
        static let SERMON_YOUTUBE = "SERMON_YOUTUBE"
        static let YOUTUBE_LIVE = "YOUTUBE_LIVE"
        static let SERVING_TURN = "SERVING_TURN"
        static let OFFERING = "OFFERING"
    }
    
    final let myEndpointRepo = URL(string: "https://script.google.com/macros/s/AKfycbwW_u3urSmxnQrIFsPxwVVzvbNnAtscBZGvxcRfYzJXuLQEWMNB/exec")
    var my_endpoints = [WebEndpoint]()
    let defaults = UserDefaults.standard
    
    func saveEndoints(){
        for item in self.my_endpoints{
            print(item.endpoint)
            defaults.set(item.url, forKey:item.endpoint)
        }
    }
    
    func downloadJson(){
        guard let downloadURL = self.myEndpointRepo else {return}
        URLSession.shared.dataTask(with: downloadURL) { data, urlResponse, error in
            print("Downloading")
            guard let data = data, error == nil, urlResponse != nil else{
                print("Something is wrong!")
                return
            }
            print("Downloaded")
            do{
                let decoder = JSONDecoder()
                let downloadedEndonts = try decoder.decode(WebEndpoints.self, from: data)
                //print(servingTurns.servingTurns[0].joycorner)
                self.my_endpoints = downloadedEndonts.endpoints
                DispatchQueue.main.async {
                    self.saveEndoints()
                }
            } catch let error as JSONError {
                print(error.rawValue)
            } catch let error as NSError {
                print(error.debugDescription)
            } catch let error{
                print(error.localizedDescription)
            }
            
            }.resume()
    }
}

