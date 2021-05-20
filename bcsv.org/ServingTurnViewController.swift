//
//  SavingTurnViewController.swift
//  bcsv.org
//
//  Created by Haksoo Kim on 8/29/19.
//  Copyright © 2019 bcsv.org. All rights reserved.
//

import UIKit

class ServingTurnViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var myActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var ServingTurnTableView: UITableView!
    let defaults = UserDefaults.standard
    var servingTurns = [ServingTurn]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
        leftSwipe.direction = .left
        rightSwipe.direction = .right
        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)
        
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
        
        // Do any additional setup after loading the view.
    }
    
    func downloadJson(){
        let url = URL(string: defaults.string(forKey: MyWebEndpoint.EndpointKey.SERVING_TURN)!)
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
                let downloadedservingTurns = try decoder.decode(ServingTurns.self, from: data)
                //print(servingTurns.servingTurns[0].joycorner)
                self.servingTurns = downloadedservingTurns.servingTurns
                DispatchQueue.main.async {
                    self.ServingTurnTableView.reloadData()
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
    
    @objc func handleSwipe(sender: UISwipeGestureRecognizer){
        if sender.state == .ended{
            switch sender.direction{
            case .left:
                dismiss(animated: true)
            case .right:
                dismiss(animated: true)
            default:
                break
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.servingTurns.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ServingCell") as? ServingTurnCell else {return UITableViewCell()}
        //cell.sundayDateLbl.text = servingTurns[indexPath.row].date
        //cell.babysitterLbl.text = servingTurns[indexPath.row].babysitter
        cell.setContent(servingTurn: servingTurns[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }

    
    @IBAction func ClouseButtonClick(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
}

