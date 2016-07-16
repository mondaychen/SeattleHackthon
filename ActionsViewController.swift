//
//  ActionsViewController.swift
//  FW_hack_lisnr
//
//  Created by Mengdi Chen on 7/15/16.
//  Copyright © 2016 Mengdi Chen. All rights reserved.
//

import UIKit

class ActionsViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let url = NSURL (string: sharedData.urlToLoad)
        let requestObj = NSURLRequest(URL: url!);
        webView.loadRequest(requestObj)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
