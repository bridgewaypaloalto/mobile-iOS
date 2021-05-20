//
//  BibleStudyViewController.swift
//  bcsv.org
//
//  Created by Haksoo Kim on 9/21/19.
//  Copyright © 2019 Haksoo Kim. All rights reserved.
//

import UIKit

class BibleReviewViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var BibleReviewTableView: UITableView!
    @IBOutlet weak var myActivityIndicator: UIActivityIndicatorView!

    var bibleReviews = [BibleReview]()
    var intermediateBibleReviews = [BibleReview]()
    let defaults = UserDefaults.standard
    var selectedIndex = -1
    var isCollapse = false
    let appendPrefix: String = "\n\n➡"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BibleReviewTableView.estimatedRowHeight = 490
        BibleReviewTableView.rowHeight = UITableView.automaticDimension
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
        let url = URL(string: defaults.string(forKey: MyWebEndpoint.EndpointKey.BIBLE_REVIEW)!)
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
                let downloadedBibleReviews = try decoder.decode(BibleReviews.self, from: data)
                
                self.bibleReviews = downloadedBibleReviews.sundayReview
                
//                // Reorder logic - Decending order by date
//                self.bibleReviews = self.bibleReviews.reversed()
//
//                // Logic for merging review, application and in_depth questions in one
//                for i in (0...self.bibleReviews.count - 1).reversed(){
//                    if self.bibleReviews[i].title?.count ?? 0 == 0{
//                        self.bibleReviews.remove(at: i)
//                    }
//                }
                
                //Merging logic
                self.bibleReviews = self.bibleReviews.reversed()
                var review_question = [String]()
                var application_question = [String]()
                var in_depth_question = [String]()
                
                for i in (0...self.bibleReviews.count - 1){
                    if (self.bibleReviews[i].title ?? "").isEmpty {
                        //This is one of review, application or in_depth question
                        if !(self.bibleReviews[i].review ?? "").isEmpty {
                            // This is review question
                            review_question.append(self.bibleReviews[i].review!)
                        }
                        
                        if !(self.bibleReviews[i].application ?? "").isEmpty {
                            // This is application question
                            application_question.append(self.bibleReviews[i].application!)
                        }
                        
                        if !(self.bibleReviews[i].in_depth ?? "").isEmpty {
                            // This is in_depth question
                            in_depth_question.append(self.bibleReviews[i].in_depth!)
                        }
                    }else{
                        //This is the main title item
                        if review_question.count > 0{
                            for j in(0...review_question.count-1).reversed(){
                                self.bibleReviews[i].review! += "\n\n" + review_question[j]
                            }
                        }
                        
                        if application_question.count > 0{
                            for j in(0...application_question.count-1).reversed(){
                                self.bibleReviews[i].application! +=  "\n\n" + application_question[j]
                            }
                        }

                        if in_depth_question.count > 0{
                            for j in(0...in_depth_question.count-1).reversed(){
                                self.bibleReviews[i].in_depth! +=  "\n\n" + in_depth_question[j]
                            }
                        }
                        
                        //Reset the string variables
                        review_question.removeAll()
                        application_question.removeAll()
                        in_depth_question.removeAll()
                    }
                }

                //Let's remove unnecessary items from the bibleReviews
                for i in (0...self.bibleReviews.count - 1).reversed(){
                    if (self.bibleReviews[i].title ?? "").isEmpty {
                        self.bibleReviews.remove(at: i)
                    }
                }
                
                DispatchQueue.main.async {
                    self.BibleReviewTableView.reloadData()
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

    enum JSONError: String, Error {
        case NoData = "ERROR: no data"
        case ConversionFailed = "ERROR: conversion from JSON failed"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.bibleReviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BibleReviewCell") as? BibleReviewCell else {return UITableViewCell()}
        
        cell.setContent(bibleReview: bibleReviews[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.selectedIndex == indexPath.row && isCollapse == true{
            return 490
        }else
        {
            return 100
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
    
    @IBAction func closeButtonClick(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
}
