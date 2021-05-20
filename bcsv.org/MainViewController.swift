//
//  ViewController.swift
//  bcsv.org
//
//  Created by Haksoo Kim on 7/28/19.
//  Copyright © 2019 Haksoo Kim. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var mainMenu: UIStackView!
    @IBOutlet weak var mainLogo: UIImageView!
    @IBOutlet weak var imgNotification: UIImageView!
    @IBOutlet weak var lblNotificationNumber: UILabel!
    
    var targetUrl: String? = nil
    var targetTitle: String? = nil
    var myUrlRequest: URLRequest? = nil
    let backgroundImageView = UIImageView()
    let alert = UIAlertController(title: "No network connection!",
                                  message: "네트워크 연결상태를 확인해주세요.",
                                  preferredStyle: .alert)
    let defaults = UserDefaults.standard
    var is_animated = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //mainMenu.isHidden = true
        
        if Reachability.isConnectedToNetwork(){
            let myEndpoint = MyWebEndpoint()
            myEndpoint.downloadJson()
            // Do any additional setup after loading the view.
            setBackground()
            fadeViewIn(view: mainLogo, delay: 0)
            
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))
            
            startListeningForBadgeUpdates()
            setupNotificationImageTapGesture()
            updateBadgeLabel()
            
        }else{
            self.present(alert, animated: true)
            print("Internet Connection not Available!")
        }
    }
    
    func setupNotificationImageTapGesture(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.notificationTapped))
        tapGesture.numberOfTouchesRequired = 1
        tapGesture.numberOfTapsRequired = 1
        imgNotification.isUserInteractionEnabled = true
        imgNotification.addGestureRecognizer(tapGesture)
    }
    
    func startListeningForBadgeUpdates(){
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.badgeWasUpdated),
                                               name: NSNotification.Name(rawValue: "com.mobile.bcsv.org.badgeWasUpdated"), object: nil)
    }
    
    @objc func notificationTapped(){
        UIApplication.shared.applicationIconBadgeNumber = 0
        lblNotificationNumber.text = ""
        lblNotificationNumber.isHidden = true
    }
    
    @objc func badgeWasUpdated(){
        updateBadgeLabel()
    }
    
    func updateBadgeLabel(){
        if UIApplication.shared.applicationIconBadgeNumber == 0{
            lblNotificationNumber.isHidden = true
        }else{
            lblNotificationNumber.isHidden = false
            lblNotificationNumber.text = String(UIApplication.shared.applicationIconBadgeNumber)
        }
    }
    
    func setBackground(){
        view.addSubview(backgroundImageView)
        self.view.sendSubviewToBack(backgroundImageView)
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        let names = ["wallpaper1", "wallpaper2", "wallpaper3", "wallpaper4", "wallpaper5"]
        let wallpaper: String = names.randomElement()!
        backgroundImageView.image = UIImage(named: wallpaper)
    }

    //MARK: BUTTON DEFINITION
    
    @IBAction func ButtonSermon_Click(_ sender: UIButton) {

        openSermonSubMenu()
        /*
            performSegue ==> it is used when multiple elements are opening the same view controller.
            Another way to do this is to make a segue line for each elements. In this case,
            performSegue method should be removed from the button click event.
         */
    }
    
    @IBAction func ButtonBulletin_Click(_ sender: UIButton) {
        openBulletinSubMenu()
    }
    
    
    @IBAction func ButtonOffering_Click(_ sender: UIButton) {

        print("Offering View")
        guard let url = URL(string: defaults.string(forKey: MyWebEndpoint.EndpointKey.OFFERING) ?? "https://bcsv.org/offering") else {return}
        UIApplication.shared.open(url)
        //self.loadWebViewContent(url: defaults.string(forKey: MyWebEndpoint.EndpointKey.OFFERING)!, title: "Offering")
    }
    
    
    @IBAction func ButtonBibleStudy_Click(_ sender: UIButton) {
        
        openBibleSubMenu()
    }
    
    @IBAction func ButtonWebsite_Click(_ sender: UIButton) {

        print("Homepage View")
        openWebContactSubMenu()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "content_identifier"
        {
            let vc = segue.destination as! VC_Content
            vc.targetUrl = self.targetUrl
            vc.myTitle = self.targetTitle
            vc.myUrlRequest = self.myUrlRequest
            
            print("It's the right path")
        }else
        {
            print("Daily Bible path")
        }
    }
    
    //MARK: WEBSITE CONTACT SUBMENU
        func openWebContactSubMenu(){
            // 1
            let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
            
            // 2
            let websiteAction = UIAlertAction(title: "Visit bcsv.org", style: .default, handler: {
                (alert: UIAlertAction!) -> Void in
                print("Visit bcsv.org")
                self.loadWebViewContent(url: self.defaults.string(forKey: MyWebEndpoint.EndpointKey.HOMEPAGE)!, title: "bcsv.org")
            })
            
            let contactAction = UIAlertAction(title: "Contact", style: .default, handler: {
                (alert: UIAlertAction!) -> Void in
                print("Contact")
                self.loadWebViewContent(url: self.defaults.string(forKey: MyWebEndpoint.EndpointKey.CONTACT)!, title: "Contact")
            })
            
            //
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
                (alert: UIAlertAction!) -> Void in
                print("Cancelled")
            })
            
            // 4
            var image = UIImage(named: "website_small")
            websiteAction.setValue(image, forKey: "image")
            optionMenu.addAction(websiteAction)
            
            image = UIImage(named: "contact_small")
            contactAction.setValue(image, forKey: "image")
            optionMenu.addAction(contactAction)
            optionMenu.addAction(cancelAction)
            
            // This is required for iPad. Otherwise the app will crash on iPad
            if let popoverController = optionMenu.popoverPresentationController {
                //popoverController.barButtonItem = sender
                popoverController.sourceView = self.view
                popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                popoverController.permittedArrowDirections = []
            }
            
            // 5
            self.present(optionMenu, animated: true, completion: nil)
        }
    //MARK: ANNOUNCEMENT SUBMENU
    func openBulletinSubMenu(){
        // 1
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
        
        // 2
        let servingTurnAction = UIAlertAction(title: "주일 당번순서", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Sunday Serving Turn")
            self.loadServingTurn()
        })
        
        let viewBulletinAction = UIAlertAction(title: "주일 광고", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Weekly Bulletin View")
            self.loadAnnouncement()
        })
        
        //
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Cancelled")
        })
        
        // 4
        var image = UIImage(named: "share")
        servingTurnAction.setValue(image, forKey: "image")
        optionMenu.addAction(servingTurnAction)
        
        image = UIImage(named: "bulletin1")
        viewBulletinAction.setValue(image, forKey: "image")
        optionMenu.addAction(viewBulletinAction)
        optionMenu.addAction(cancelAction)
        
        // This is required for iPad. Otherwise the app will crash on iPad
        if let popoverController = optionMenu.popoverPresentationController {
            //popoverController.barButtonItem = sender
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        // 5
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    
    //MARK: BIBLE SUBMENU
    func openBibleSubMenu(){
        // 1
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
        
        // 2
        let bibleTextAction = UIAlertAction(title: "주일 설교 본문", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Sunday Bible Text")
            self.loadBibleText()
        })
        
        let bibleReviewAction = UIAlertAction(title: "주일 설교 리뷰", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Bible Review")
            self.loadBibleReview()
        })
        
        //
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Cancelled")
        })
        
        // 4
        var image = UIImage(named: "bible_small")
        bibleTextAction.setValue(image, forKey: "image")
        optionMenu.addAction(bibleTextAction)
        
        image = UIImage(named: "study")
        bibleReviewAction.setValue(image, forKey: "image")
        optionMenu.addAction(bibleReviewAction)
        optionMenu.addAction(cancelAction)
        
        // This is required for iPad. Otherwise the app will crash on iPad
        if let popoverController = optionMenu.popoverPresentationController {
            //popoverController.barButtonItem = sender
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        // 5
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    //MARK: SERMON SUBMENU
    func openSermonSubMenu(){
        // 1
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
        
        // 2
        let bibleTextAction = UIAlertAction(title: "주일 설교", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Sermon Youtube Viewer")
            self.loadWebViewContent(url: self.defaults.string(forKey: MyWebEndpoint.EndpointKey.SERMON_YOUTUBE)!, title: "주일 설교")
        })
        
        let bibleLiveAction = UIAlertAction(title: "주일 설교 Live", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Sermon Live Viewer")
            self.loadLiveStreamingPage()
        })
        
        let bibleReviewAction = UIAlertAction(title: "Audio 듣기", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Sermon Audio Viewer")
            self.loadWebViewContent(url: self.defaults.string(forKey: MyWebEndpoint.EndpointKey.SERMON_AUDIO)!, title: "Audio 듣기")
        })
        
        //
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Cancelled")
        })
        
        // 4
        var image = UIImage(named: "bible_small")
        bibleTextAction.setValue(image, forKey: "image")
        optionMenu.addAction(bibleTextAction)
        
        image = UIImage(named: "youtube")
        bibleLiveAction.setValue(image, forKey: "image")
        optionMenu.addAction(bibleLiveAction)
        
        image = UIImage(named: "announcement")
        bibleReviewAction.setValue(image, forKey: "image")
        optionMenu.addAction(bibleReviewAction)
        
        optionMenu.addAction(cancelAction)
        
        // This is required for iPad. Otherwise the app will crash on iPad
        if let popoverController = optionMenu.popoverPresentationController {
            //popoverController.barButtonItem = sender
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        // 5
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    //MARK: LOAD SCREEN DEFINITION
    func loadWebViewContent(url: String, title: String){
        if Reachability.isConnectedToNetwork(){
            print("Internet Connection Available!")
            targetUrl = url
            targetTitle = title
            
            let url = URL(string: targetUrl!)!
            myUrlRequest = URLRequest(url: url)
            myUrlRequest?.httpMethod = "GET"
            
            performSegue(withIdentifier: "content_identifier", sender: self)
        }else{
            self.present(alert, animated: true)
            print("Internet Connection not Available!")
        }
    }
    
    func loadServingTurn(){
        if Reachability.isConnectedToNetwork(){
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "SB_ServingTurn") as! ServingTurnViewController
            self.present(newViewController, animated: true, completion: nil)
            
        }else{
            self.present(alert, animated: true)
            print("Internet Connection not Available!")
        }
    }
    
    func loadAnnouncement(){
        if Reachability.isConnectedToNetwork(){
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "SB_Announcement") as! AnnouncementViewController
            self.present(newViewController, animated: true, completion: nil)
            
        }else{
            self.present(alert, animated: true)
            print("Internet Connection not Available!")
        }
    }
    
    func loadBibleText(){
        if Reachability.isConnectedToNetwork(){
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "SB_SundayBible") as! SundayBibleViewController
            self.present(newViewController, animated: true, completion: nil)
            
        }else{
            self.present(alert, animated: true)
            print("Internet Connection not Available!")
        }
    }
    
    func loadBibleReview(){
        if Reachability.isConnectedToNetwork(){
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "SB_BibleReview") as! BibleReviewViewController
            self.present(newViewController, animated: true, completion: nil)
        }else{
            self.present(alert, animated: true)
            print("Internet Connection not Available!")
        }
    }
    
    // MARK: ANIMATION
    func fadeViewIn(view : UIView, delay: TimeInterval) {
        
        let animationDuration = 3.0
        UIView.animate(withDuration: animationDuration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
             view.alpha = 1.0
        }, completion: nil)
        
//        UIView.animate(withDuration: animationDuration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
//            view.alpha = 1.0
//        }, completion: { (finished: Bool) in
//            self.showMainMenu()
//        })
    }
    
    func fadeViewOut(view : UIView, delay: TimeInterval) {
        
        let animationDuration = 2.0
        
        UIView.animate(withDuration: animationDuration, delay: delay, options: [UIView.AnimationOptions.autoreverse, UIView.AnimationOptions.curveEaseOut], animations: {
            view.alpha = 0
        }, completion: nil)
    }
    
    func animateView(){
        self.mainMenu.axis = .vertical
        
        let animations = {
            self.mainMenu.axis = .vertical
            self.mainMenu.alpha = 1
            self.mainMenu.transform = CGAffineTransform.identity
            //self.view.layoutIfNeeded()
        }
        
        //Original state
        self.mainMenu.transform = CGAffineTransform(scaleX: 0, y: 0)
        self.mainMenu.alpha = 0
        
        //Animiate them all
        UIView.animate(withDuration: 2, delay: 2, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.7, options: .transitionCurlDown, animations: animations, completion: {(finished: Bool) in self.showNotiNumber()})
    }
    
    func showNotiNumber(){
        self.imgNotification.alpha = 0.7
        self.lblNotificationNumber.alpha = 0.7
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (self.is_animated){
            animateView()
            self.is_animated = false
        }
    }
    
    func loadLiveStreamingPage() {

        let myEndpoint = MyWebEndpoint()
        let group = DispatchGroup()
        group.enter()

        // avoid deadlocks by not using .main queue here
        DispatchQueue.global(qos: .background).async {
            myEndpoint.downloadJson()
            group.leave()
        }

        // wait ...
        group.wait()
        print("Sync finished!")
        print("Loading Live Streaming Page!")
        self.loadWebViewContent(url: self.defaults.string(forKey: MyWebEndpoint.EndpointKey.YOUTUBE_LIVE)!, title: "주일 설교 Live")
        
    }
}



