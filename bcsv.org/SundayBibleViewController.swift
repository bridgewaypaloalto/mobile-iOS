//
//  SundayBibleViewController.swift
//  bcsv.org
//
//  Created by admin on 9/8/19.
//  Copyright © 2019 Haksoo Kim. All rights reserved.
//

import UIKit

class SundayBibleViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var myActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var SundayBibleTableView: UITableView!
    var sundayBibles = [SundayBible]()
    var intermediateSundayBibles = [SundayBible]()
    let defaults = UserDefaults.standard
    var selectedIndex = -1
    var isCollapse = false
    var tempView: UITextView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SundayBibleTableView.estimatedRowHeight = 490
        SundayBibleTableView.rowHeight = UITableView.automaticDimension
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
        
//        let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
//        tap.numberOfTapsRequired = 2
//        view.addGestureRecognizer(tap)
    }
    
//    @objc func doubleTapped() {
//        // do something here
//        let alert = UIAlertController(title: "Double tapped!",
//                                      message: "Creating PDF file.",
//                                      preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))
//        self.present(alert, animated: true)
//
//    }
    
    func downloadJson(){
        let url = URL(string: defaults.string(forKey: MyWebEndpoint.EndpointKey.BIBLE_TEXT)!)
        guard let downloadURL = url else {return}
        
        URLSession.shared.dataTask(with: downloadURL) { data, urlResponse, error in
            print("Downloading")
            guard let data = data, error == nil, urlResponse != nil else{
                print("Something is wrong!")
                return
            }
            print("Downloaded")
            print(data)
            do{
                let decoder = JSONDecoder()
                let downloadedsundayBibles = try decoder.decode(SundayBibles.self, from: data)

                self.sundayBibles = downloadedsundayBibles.bibleText
                
                // Reorder logic - Decending order by date
                self.sundayBibles = self.sundayBibles.reversed()
                
                
                // Logic for appending the refernces to the main text
                var tempRefText = [SundayBible]()
                var refText = ""
                for item in self.sundayBibles {
                    if item.Title?.count ?? 0 == 0{
                        tempRefText.append(item)
                    }
                    else{
                        for ref in tempRefText.reversed(){
                            refText += "\n📚(참고) " + ref.Bible_chapter! + "\n" + ref.Bible_text! + "\n"
                        }
                        
                        item.appendBibleText(text: refText)
                        //self.sundayBibles.append(item)
                        
                        refText = ""
                        tempRefText.removeAll()
                    }
                }
                
                //Remove reference items from the array
                for i in (0...self.sundayBibles.count - 1).reversed(){
                    if self.sundayBibles[i].Title?.count ?? 0 == 0{
                        self.sundayBibles.remove(at: i)
                    }
                }
                
                DispatchQueue.main.async {
                    self.SundayBibleTableView.reloadData()
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
        return self.sundayBibles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SundayBibleCell") as? SundayBibleCell else {return UITableViewCell()}

        cell.setContent(sundayBible: sundayBibles[indexPath.row])
        tempView = cell.bibleTextLbl
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func closeButtonClick(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
}

