//
//  VC_Sermon.swift
//  bcsv.org
//
//  Created by Haksoo Kim on 7/28/19.
//  Copyright © 2019 Haksoo Kim. All rights reserved.
//

import UIKit
import WebKit

class VC_Content: UIViewController {

    @IBOutlet weak var myActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var myWebView: WKWebView!
    @IBOutlet weak var myTitleBar: UINavigationItem!
    var targetUrl: String? = nil
    var myTitle: String? = nil
    var myUrlRequest: URLRequest? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        myTitleBar.title = myTitle
        myWebView.load(myUrlRequest!)
        myWebView.addObserver(self, forKeyPath: #keyPath(WKWebView.isLoading), options: .new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "loading"{
            if myWebView.isLoading{
                myActivityIndicator.startAnimating()
                myActivityIndicator.isHidden = false
            }else{
                myActivityIndicator.stopAnimating()
                myActivityIndicator.isHidden = true
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
