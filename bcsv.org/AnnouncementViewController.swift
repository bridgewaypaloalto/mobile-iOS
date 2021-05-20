//
//  AnnouncementViewController.swift
//  bcsv.org
//
//  Created by Haksoo on 11/19/19.
//  Copyright © 2019 Haksoo Kim. All rights reserved.
//

import UIKit

class AnnouncementViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var AnnouncementTableView: UITableView!
    @IBOutlet weak var myActivityIndicator: UIActivityIndicatorView!
    let defaults = UserDefaults.standard
    var announcements = [Announcement]()
    //final let url = URL(string: EndPoint.getEndpoint(endpoint: EndPoint.endpoints.ANNOUNCEMENT))
    var selectedIndex = -1
    var isCollapse = false
    
    enum JSONError: String, Error {
        case NoData = "ERROR: no data"
        case ConversionFailed = "ERROR: conversion from JSON failed"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        AnnouncementTableView.estimatedRowHeight = 620
        AnnouncementTableView.rowHeight = UITableView.automaticDimension
        
        // Do any additional setup after loading the view.
        
        if Reachability.isConnectedToNetwork(){
            self.view.bringSubviewToFront(myActivityIndicator)
            
            //Start Activity Indicator
            self.myActivityIndicator.startAnimating()
            self.myActivityIndicator.isHidden = false
            downloadJson()
        }else{
            let alert = UIAlertController(title: "No internet connection!",
                                          message: "Please check your network connection.",
                                          preferredStyle: .alert)
            self.present(alert, animated: true)
            print("Internet Connection not Available!")
        }
    }
    
    func downloadJson(){
        let url = URL(string: defaults.string(forKey: MyWebEndpoint.EndpointKey.ANNOUNCEMENT)!)
        guard let downloadURL = url else {return}
        URLSession.shared.dataTask(with: downloadURL) { data, urlResponse, error in
            print("Downloading")
            guard let data = data, error == nil, urlResponse != nil else{
                print("Something is wrong!")
                return
            }
            print("Downloaded")
            do{
                let decoder = JSONDecoder()
                let downloadedAnnouncements = try decoder.decode(Announcements.self, from: data)
                //print(servingTurns.servingTurns[0].joycorner)
                self.announcements = downloadedAnnouncements.announcements
                DispatchQueue.main.async {
                    self.AnnouncementTableView.reloadData()
                    self.myActivityIndicator.stopAnimating()
                    self.myActivityIndicator.isHidden = true
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.announcements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "identifier_announcement") as? AnnouncementCell else {return UITableViewCell()}
        //cell.sundayDateLbl.text = servingTurns[indexPath.row].date
        //cell.babysitterLbl.text = servingTurns[indexPath.row].babysitter
        cell.setContent(announcement: announcements[indexPath.row])
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.selectedIndex == indexPath.row && isCollapse == true{
            return 620
        }else
        {
            return 110
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if selectedIndex == indexPath.row{
            if self.isCollapse == false{
                self.isCollapse = true
            }else{
                self.isCollapse = false
            }
            
        }else{
            self.isCollapse = true
        }
        self.selectedIndex = indexPath.row
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }

    
    @IBAction func ClouseButtonClick(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
}
