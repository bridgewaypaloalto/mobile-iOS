//
//  dailyBible2_ViewController.swift
//  bcsv.org
//
//  Created by admin on 8/7/19.
//  Copyright © 2019 Haksoo Kim. All rights reserved.
//
//  Due to the legal issues of using contents from su.or.kr, this page should be hidden
//


import UIKit

class dailyBible2_ViewController: UIViewController {

    @IBOutlet weak var LabelDate: UITextField!
    @IBOutlet weak var BibleCommentTextView: UITextView!
    @IBOutlet weak var LabelChapter: UITextField!
    @IBOutlet weak var LabelTitle: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // bibleScript is defined in dailyBible1_ViewController
        
        //Display Header information
        LabelDate.attributedText = fontFormatter(targetString: myHeader.date, type: "S")
        LabelChapter.attributedText = fontFormatter(targetString: myHeader.chapter_verse, type: "S")
        LabelTitle.attributedText = fontFormatter(targetString: myHeader.title, type: "H")
        
        //Container string where it contains whole attributed string
        let mutableAttributedString = NSMutableAttributedString()

        let comment1_AttrString = fontFormatter(targetString: "\n" + bibleCont!.Qt_Brf.replacingOccurrences(of:"<br>", with:"\n"), type: "BL")
        let title1_AttrString = fontFormatter(targetString: "\n하나님은 어떤 분입니까?\n\n", type: "H")
        let title1Content_AttrString = fontFormatter(targetString: bibleCont!.Qt_a1.replacingOccurrences(of:"<br>", with:"\n"), type: "B")
        let title2_AttrString = fontFormatter(targetString: "\n내게 주시는 교훈은 무엇입니까?\n\n", type: "H")
        let title2Content_AttrString = fontFormatter(targetString: bibleCont!.Qt_a2.replacingOccurrences(of:"<br>", with:"\n"), type: "B")
        let title3_AttrString = fontFormatter(targetString: "\n기도\n\n", type: "H")
        let title3Content_AttrString = fontFormatter(targetString: bibleCont!.Qt_a3.replacingOccurrences(of:"<br>", with:"\n\n"), type: "B")

        mutableAttributedString.append(comment1_AttrString)
        mutableAttributedString.append(title1_AttrString)
        mutableAttributedString.append(title1Content_AttrString)
        mutableAttributedString.append(title2_AttrString)
        mutableAttributedString.append(title2Content_AttrString)
        mutableAttributedString.append(title3_AttrString)
        mutableAttributedString.append(title3Content_AttrString)

        //BibleCommentTextView.attributedText = mutableAttributedString
    }
    
    func fontFormatter(targetString: String, type: String)->NSMutableAttributedString{
        let string = targetString
        let attributedString = NSMutableAttributedString(string: string)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .justified
        paragraphStyle.firstLineHeadIndent = 5.0
        
        switch type {
        case "H":
            //Header or Title font
            let H1_Attributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor.lightGray,
                .backgroundColor: UIColor.black,
                .font: UIFont.boldSystemFont(ofSize: 20)]
            
            attributedString.addAttributes(H1_Attributes, range: NSRange(location: 0, length: string.count))
            
        case "S":
            //Small or date time
            let H2_Attributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor.lightGray,
                .backgroundColor: UIColor.black,
                .font: UIFont.systemFont(ofSize: 14)]
            
            attributedString.addAttributes(H2_Attributes, range: NSRange(location: 0, length: string.count))
            
        case "B":
            //Body
            let body_Attributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor.white,
                .backgroundColor: UIColor.black,
                .paragraphStyle: paragraphStyle,
                .font: UIFont.systemFont(ofSize: 17)]
            
            attributedString.addAttributes(body_Attributes, range: NSRange(location: 0, length: string.count))
            
        case "BL":
            //Body top
            let body_Attributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor.white,
                .backgroundColor: UIColor.black,
                .paragraphStyle: paragraphStyle,
                .font: UIFont.italicSystemFont(ofSize: 20)]
            
            attributedString.addAttributes(body_Attributes, range: NSRange(location: 0, length: string.count))
            
        default:
            //Default
            let body_Attributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor.white,
                .backgroundColor: UIColor.black,
                .font: UIFont.systemFont(ofSize: 20)]
            
            attributedString.addAttributes(body_Attributes, range: NSRange(location: 0, length: string.count))
        }

        return attributedString

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
