//
//  ViewController.swift
//  Koloda
//
//  Created by Eugene Andreyev on 4/23/15.
//  Copyright (c) 2015 Eugene Andreyev. All rights reserved.
//

import UIKit
import Koloda

private var numberOfCards: UInt = 1

class ViewController: UIViewController {
    
    @IBOutlet var parent: UIView!
    @IBOutlet weak var detecterView: UIView!
    @IBOutlet weak var kolodaView: KolodaView!
    @IBOutlet weak var likenessButtonsView: UIView!

    @IBOutlet weak var WebGIf: UIWebView!
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 0.078, green: 0.078, blue: 0.078, alpha: 1.00)
        
        
        if sharedData.currentAdId == nil {
            kolodaView.alpha = 0
            likenessButtonsView.alpha = 0
            detecterView.alpha = 1
        } else {
            detecterView.alpha = 0
            kolodaView.alpha = 1
            likenessButtonsView.alpha = 1
            kolodaView.resetCurrentCardIndex()
        }
        
        kolodaView.dataSource = self
        kolodaView.delegate = self
        
        self.modalTransitionStyle = UIModalTransitionStyle.FlipHorizontal
        WebGIf.opaque = false;
        WebGIf.backgroundColor = UIColor.clearColor()
        let htmlString = "<!DOCTYPE html><html> <head> <style> body {background-color: #141414; } h1 {color: white; text-align: center; } p {font-family: sans-serif; font-size: 20px;} </style> </head> <body> <br/><br/><br/><br/><img width=\"310px\" src=\"https://31.media.tumblr.com/8f648ca8b5cb7848c66706c68d7fed54/tumblr_n7f9955y7h1shpedgo1_500.gif\"><br/><br/></img> <h1>Listening...</h1> </body> </html>"
        WebGIf.loadHTMLString(htmlString, baseURL: nil)
        
    }
    
    func adDetected() {
        kolodaView.fadeIn(duration: 0.2)
        likenessButtonsView.fadeIn(duration: 0.2)
        kolodaView.resetCurrentCardIndex()
        detecterView.fadeOut()
    }
    
    
    //MARK: IBActions
    @IBAction func fakeAdDetected(sender: AnyObject) {
        self.adDetected()
    }
    @IBAction func leftButtonTapped() {
        kolodaView?.swipe(SwipeResultDirection.Left)
    }
    
    @IBAction func rightButtonTapped() {
        kolodaView?.swipe(SwipeResultDirection.Right)
    }
    

}

//MARK: KolodaViewDelegate
extension ViewController: KolodaViewDelegate {
    
    func kolodaDidRunOutOfCards(koloda: KolodaView) {
//        kolodaView.resetCurrentCardIndex()
    }
    
    func koloda(koloda: KolodaView, didSwipeCardAtIndex index: UInt, inDirection direction: SwipeResultDirection) {
        let dislikeUrl = "http://striveforfreedom.net:8080/index.html?tone_id=\(sharedData.lastAdId)&type=dislike"
        let likeUrl = "http://striveforfreedom.net:8080/index.html?tone_id=\(sharedData.lastAdId)&type=like"
        print(dislikeUrl)
        print(likeUrl)
        sharedData.urlToLoad = (direction == SwipeResultDirection.Left) ? dislikeUrl : likeUrl
        let actionVC = self.storyboard?.instantiateViewControllerWithIdentifier("Actions") as! ActionsViewController
        self.presentViewController(actionVC, animated: true, completion: nil)
        likenessButtonsView.fadeOut(duration: 0.2)
        kolodaView.fadeOut(duration: 0.2)
        detecterView.fadeIn(duration: 0.2)
        sharedData.currentAdId = nil
    }
}

//MARK: KolodaViewDataSource
extension ViewController: KolodaViewDataSource {
    
    func kolodaNumberOfCards(koloda:KolodaView) -> UInt {
        return UInt(sharedData.imageSource == nil ? 0 : 1)
    }
    
    func koloda(koloda: KolodaView, viewForCardAtIndex index: UInt) -> UIView {
        return UIImageView(image: sharedData.imageSource)
    }
    
    func koloda(koloda: KolodaView, viewForCardOverlayAtIndex index: UInt) -> OverlayView? {
        return NSBundle.mainBundle().loadNibNamed("OverlayView",
            owner: self, options: nil)[0] as? OverlayView
    }
}

extension UIView {
    
    /**
     Fade in a view with a duration
     
     - parameter duration: custom animation duration
     */
    func fadeIn(duration duration: NSTimeInterval = 1.0) {
        UIView.animateWithDuration(duration, animations: {
            self.alpha = 1.0
        })
    }
    
    /**
     Fade out a view with a duration
     
     - parameter duration: custom animation duration
     */
    func fadeOut(duration duration: NSTimeInterval = 1.0) {
        UIView.animateWithDuration(
            duration,
            animations: {
                self.alpha = 0.0
            }
        )
    }
    
}

