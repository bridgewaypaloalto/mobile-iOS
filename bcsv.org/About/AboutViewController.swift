//
//  AboutViewController.swift
//  bcsv.org
//
//  Created by Haksoo on 9/27/19.
//  Copyright © 2019 Haksoo Kim. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    @IBOutlet weak var url_link_textview: UITextView!
    @IBOutlet weak var about_Lbl: UILabel!
    @IBOutlet weak var copyright_lbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let buildNumber: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
        let myVersion: String? = UIApplication.appVersion! + "(" + buildNumber + ")"
        let year: String = String(Calendar.current.component(.year, from: Date()))
        let copyright: String? = "Copyright © " + year
        about_Lbl.text = myVersion
        copyright_lbl.text = copyright
        
        // Do any additional setup after loading the view.
        url_link_textview.isSelectable = true
        url_link_textview.isEditable = false
        let path = "https://bcsv.org/about"
        let text = url_link_textview.text!
        let attributedString = NSAttributedString.makeHyperLink(for: path, in: text, as: "https://bcsv.org")
        let font = url_link_textview.font
        let alignment = url_link_textview.textAlignment
        url_link_textview.attributedText = attributedString
        url_link_textview.font = font
        url_link_textview.textAlignment = alignment
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

extension UIApplication {
    static var appVersion: String? {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }
}

extension NSAttributedString {
    static func makeHyperLink(for path: String, in string: String, as substring: String)->NSAttributedString{
        let nsString = NSString(string: string)
        let substringRange = nsString.range(of: substring)
        let attributedString = NSMutableAttributedString(string: string)
        attributedString.addAttribute(.link, value: path, range: substringRange)
        return attributedString
    }
}
