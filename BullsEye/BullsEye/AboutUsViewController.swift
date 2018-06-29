//
//  AboutUsViewController.swift
//  BullsEye
//
//  Created by Divyanshu Goel on 23/06/18.
//  Copyright © 2018 Divyanshu Goel. All rights reserved.
//

import UIKit
import WebKit

class AboutUsViewController: UIViewController {

    @IBOutlet weak var aboutWebView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let htmlFile = Bundle.main.path(forResource: "BullsEye", ofType: "html") {
            let htmlData = NSData(contentsOfFile: htmlFile)
            let baseURL = NSURL.fileURL(withPath: Bundle.main.bundlePath)
            aboutWebView.load(htmlData! as Data, mimeType: "text/html",
                                  characterEncodingName: "UTF-8", baseURL: baseURL)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func closeButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
