//
//  dailyBible1_ViewController.swift
//  bcsv.org
//
//  Created by admin on 8/7/19.
//  Copyright © 2019 Haksoo Kim. All rights reserved.
//

import UIKit

//>>> Containers

struct BibleCommentary: Decodable{
    let Base_de: String
    let Bible_name: String
    let Bible_chapter: String
    let Qt_sj: String
    let Qt_Brf: String
    let Qt_a1: String
    let Qt_a2: String
    let Qt_a3: String
}

struct BibleScript: Decodable{
    let Bible_Cn: String
    let Chapter: Int
    let Verse: Int
}

//<<< End Containers

//>>> Display purpose
struct Header{
    var date: String
    var chapter_verse: String
    var title: String
}

var bibleCont: BibleCommentary?

var myHeader = Header(date: "",
                      chapter_verse: "",
                      title: "")
var bibleScript: [BibleScript]? = nil
let alert = UIAlertController(title: "No network connection!",
                              message: "네트워크 연결상태를 확인해주세요.",
                              preferredStyle: .alert)
//<<< Display purpose


class dailyBible1_ViewController: UIViewController {

    @IBOutlet weak var BibleScriptTextView: UITextView!
    @IBOutlet weak var myActivityIndicator: UIActivityIndicatorView!
    var pinchGestureRecognizer : UIPinchGestureRecognizer!
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Alert for network reachability check
        if alert.actions.count == 0{
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))
        }
        
        if Reachability.isConnectedToNetwork(){
            print("Internet Connection is Available!")
            loadContents()
        }else{
            self.present(alert, animated: true)
            print("Internet Connection not Available!")
        }
        
        pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(pinchGesture))
        self.BibleScriptTextView.addGestureRecognizer(pinchGestureRecognizer)
        
        // Definition of double tap gesture
        let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        tap.numberOfTapsRequired = 2
        BibleScriptTextView.addGestureRecognizer(tap)
    }
    
    @objc func pinchGesture(gestureRecognizer: UIPinchGestureRecognizer ) {
        print("*** Pinch: Scale: \(gestureRecognizer.scale) Velocity: \(gestureRecognizer.velocity)")
        
        let font = self.BibleScriptTextView.font
        var pointSize = font?.pointSize
        let fontName = font?.fontName
        
        pointSize = ((gestureRecognizer.velocity > 0) ? 1 : -1) * 1 + pointSize!;
        
        if (pointSize! < 13) { pointSize = 13}
        if (pointSize! > 42) { pointSize = 42}
            
        self.BibleScriptTextView.font = UIFont(name: fontName!, size: pointSize!)
    }
    
    @objc func doubleTapped() {
        // do something here
         print("Double tapped detected.")
        if #available(iOS 9,*) {
            self.BibleScriptTextView.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.regular);
        } else {
            self.BibleScriptTextView.font = UIFont.systemFont(ofSize: 17);
        }
    }
    
    func getDate() -> String{
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        let formattedDate = format.string(from: date)
        
        return formattedDate
    }
    
    enum JSONError: String, Error {
        case NoData = "ERROR: no data"
        case ConversionFailed = "ERROR: conversion from JSON failed"
    }
    
    func loadContents(){
        
        //Daily Bible Commentary Section
        self.view.bringSubviewToFront(myActivityIndicator)
        let endpoint = self.defaults.string(forKey: MyWebEndpoint.EndpointKey.DAILY_BIBLE1)!
        let url = URL(string: endpoint)!
        executeNetworkRequestDic(url: url, type: "BodyBibleCont", completion: CompletionHandlerDic(value:))
        
    }
    
    func CompletionHandlerDic(value: Any) {

        //BodyBibleCont
        //This handler displays Bible Commentary
        
        DispatchQueue.main.async {

            bibleCont = (value as! BibleCommentary)
            
            //print("Function completion handler value: \(value)")
            
            //Building header struct for page 2
            myHeader.date = bibleCont!.Base_de
            let bibleName = bibleCont?.Bible_name
            let verse = bibleCont?.Bible_chapter
            myHeader.chapter_verse = bibleName! + verse!
            myHeader.title = bibleCont!.Qt_sj
            
            
            //Bible Script section!
            //This section is intentionally blocked due to licese issue with SU.OR.KR
            let endpoint = self.defaults.string(forKey: MyWebEndpoint.EndpointKey.DAILY_BIBLE2)!
            let url = URL(string: endpoint)!
            self.executeNetworkRequest(url: url, type: "BodyBible", completion: self.CompletionHandler(value:))
        }
    }
    
    func CompletionHandler(value: [Any]) {
        
        DispatchQueue.main.async { // Correct
            self.myActivityIndicator.stopAnimating()
            self.myActivityIndicator.isHidden = true
            
            //Display logic is in dailyBible2_ViewController.swift
            bibleScript = (value as! [BibleScript])
            
            //Container string where it contains whole attributed string
            let mutableAttributedString = NSMutableAttributedString()
            
            //--->>> Daily Bible Scripts
            let title = self.fontFormatter(targetString: "\n오늘의 말씀\n\n", type: "Title")
            let date = self.fontFormatter(targetString: "\n" + myHeader.date, type: "Small")
            let chapter_verse = self.fontFormatter(targetString: "\n" + myHeader.chapter_verse + "\n\n", type: "Small")
            //let title = self.fontFormatter(targetString: "\n" + myHeader.title + "\n\n", type: "Title")
            
            mutableAttributedString.append(title)
            mutableAttributedString.append(date)
            mutableAttributedString.append(chapter_verse)
            //mutableAttributedString.append(title)

            for item in bibleScript!{
                mutableAttributedString.append(self.fontFormatter(targetString: String(item.Chapter) + ":" + String(item.Verse) + "\n", type: "Small"))
                mutableAttributedString.append(self.fontFormatter(targetString: item.Bible_Cn + "\n\n", type: "Body"))
            }
            
            self.BibleScriptTextView.attributedText = mutableAttributedString
            
            if #available(iOS 13.0, *) {
                let dynamicColor = UIColor {(traitCollection: UITraitCollection) -> UIColor in
                    switch traitCollection.userInterfaceStyle{
                    case .unspecified, .light: return .black
                        
                    case .dark:
                        return .lightText
                    @unknown default:
                        return .black
                    }
                }
                
                self.BibleScriptTextView.textColor = dynamicColor
            } else {
                // Fallback on earlier versions
            }
            //<<<---
        }
    }
    
    func fontFormatter(targetString: String, type: String)->NSMutableAttributedString{
        let string = targetString
        let attributedString = NSMutableAttributedString(string: string)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .justified
        paragraphStyle.firstLineHeadIndent = 5.0
        
        let titleStyle = NSMutableParagraphStyle()
        titleStyle.alignment = .center
        titleStyle.firstLineHeadIndent = 5.0
        
        let smallStyle = NSMutableParagraphStyle()
        titleStyle.alignment = .left
        titleStyle.firstLineHeadIndent = 5.0
        
        switch type {
        case "Title":
            //Header or Title font
            let H1_Attributes: [NSAttributedString.Key: Any] = [
                .paragraphStyle: titleStyle,
                .font: UIFont.boldSystemFont(ofSize: 25)]
            
            attributedString.addAttributes(H1_Attributes, range: NSRange(location: 0, length: string.count))
            
        case "Small":
            //Small or date time
            let H2_Attributes: [NSAttributedString.Key: Any] = [
                .paragraphStyle: smallStyle,
                .font: UIFont.systemFont(ofSize: 14)]
            
            attributedString.addAttributes(H2_Attributes, range: NSRange(location: 0, length: string.count))
            
        case "Body":
            //Body
            let body_Attributes: [NSAttributedString.Key: Any] = [
                .paragraphStyle: paragraphStyle,
                .font: UIFont.systemFont(ofSize: 17)]
            
            attributedString.addAttributes(body_Attributes, range: NSRange(location: 0, length: string.count))
            
        default:
            //Default
            let body_Attributes: [NSAttributedString.Key: Any] = [
                .paragraphStyle: paragraphStyle,
                .font: UIFont.systemFont(ofSize: 20)]
            
            attributedString.addAttributes(body_Attributes, range: NSRange(location: 0, length: string.count))
        }
        
        return attributedString
        
    }
    
    func executeNetworkRequest(url: URL, type: String, completion: ([Any]) -> Void) {
        
        //This request should return Array<Any> type
        
        var request = URLRequest(url: url)
        let formattedDate = getDate()
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let json = [
            "qt_ty": "QT1",
            "Base_de": formattedDate
        ]
        
        let jsonData = try! JSONSerialization.data(withJSONObject: json, options: [])
        request.httpBody = jsonData
        
        //Start Activity Indicator
//        self.myActivityIndicator.startAnimating()
//        self.myActivityIndicator.isHidden = false
        
        var myText: [Any]? = nil
        let task = URLSession.shared.dataTask(with: request, completionHandler:{(data, response, error) in
            do {
                let decoder = JSONDecoder()
                if type == "BodyBible"{
                    myText = try decoder.decode([BibleScript].self, from: data!)
                } else {
                    print("Error in JSONDecoder for BodyBible")
                }
                
                self.CompletionHandler(value: myText!)
                
            } catch let error as JSONError {
                print(error.rawValue)
            } catch let error as NSError {
                print(error.debugDescription)
            } catch let error{
                print(error.localizedDescription)
            }
        })
        
        task.resume()
    }
    
    func executeNetworkRequestDic(url: URL, type: String, completion: (Any) -> Void) {
        
        //This request should return dictionary type
        
        var request = URLRequest(url: url)
        let formattedDate = getDate()
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let json = [
            "qt_ty": "QT1",
            "Base_de": formattedDate
        ]
        
        let jsonData = try! JSONSerialization.data(withJSONObject: json, options: [])
        request.httpBody = jsonData
        
        //Start Activity Indicator
        self.myActivityIndicator.startAnimating()
        self.myActivityIndicator.isHidden = false
        
        var myText: Any? = nil
        let task = URLSession.shared.dataTask(with: request, completionHandler:{(data, response, error) in
            do {
                let decoder = JSONDecoder()
                
                if type == "BodyBibleCont"{
                    myText = try decoder.decode(BibleCommentary.self, from: data!)
                }
                
                self.CompletionHandlerDic(value: myText!)
                
            } catch let error as JSONError {
                print(error.rawValue)
            } catch let error as NSError {
                print(error.debugDescription)
            } catch let error{
                print(error.localizedDescription)
            }
        })
        
        task.resume()
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
