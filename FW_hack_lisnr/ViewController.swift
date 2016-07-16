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
let LISNRServiceAPIKey = "f26b1887-eb2e-48ff-9644-3f75f72652bb"
var backgrounded:Bool!

class ViewController: UIViewController, LISNRServiceDelegate{
    
    @IBOutlet var parent: UIView!
    @IBOutlet weak var detecterView: UIView!
    @IBOutlet weak var kolodaView: KolodaView!
    @IBOutlet weak var likenessButtonsView: UIView!

    private var imageSource: Array<UIImage> = {
        var array: Array<UIImage> = []
        for index in 0..<numberOfCards {
            array.append(UIImage(named: "Card_like_\(index + 1)")!)
        }
        
        return array
    }()
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        kolodaView.alpha = 0
        likenessButtonsView.alpha = 0
        
        kolodaView.dataSource = self
        kolodaView.delegate = self
        
        self.modalTransitionStyle = UIModalTransitionStyle.FlipHorizontal
        
        LISNRService.sharedService().configureWithApiKey(LISNRServiceAPIKey, completion: { (error: NSError?) -> Void in
            
            if error != nil {
//                let nav = self.window?.rootViewController as! UINavigationController
//                let vc = nav.viewControllers.first as! ViewController
//                
//                dispatch_async(dispatch_get_main_queue()) {
//                    vc.startStopListeningButton.enabled = false
//                    vc.startStopListeningButton.setNeedsDisplay()
//                }
                
                print("Unable to start LISNRService. Error: \(error)")
            }
        })
        
        LISNRService.sharedService().addObserver(self)
        LISNRService.sharedService().setUserAnalyticsIdentifier("Your uuid for user")
        LISNRContentManager.sharedContentManager().configureWithLISNRService(LISNRService.sharedService())
        LISNRContentManager.sharedContentManager().delegate = UIApplication.sharedApplication().delegate as? LISNRContentManagerDelegate
        backgrounded = false
        LISNRService.sharedService().startListeningWithCompletion({ (error) -> Void in
            if error == nil {
//                self.startStopListeningButton.setTitle("Stop Listening", forState: UIControlState.Normal)
                print("Start listening")
                LISNRService.sharedService().enableBackgroundListening = true

            } else {
                print("Unable to start listening . Error: \(error)")
            }
            
        })
    }
    
    
    //MARK: IBActions
    @IBAction func fakeAdDetected(sender: AnyObject) {
        kolodaView.fadeIn()
        likenessButtonsView.fadeIn()
        detecterView.fadeOut()
    }
    @IBAction func leftButtonTapped() {
        kolodaView?.swipe(SwipeResultDirection.Left)
    }
    
    @IBAction func rightButtonTapped() {
        kolodaView?.swipe(SwipeResultDirection.Right)
    }
    
    @IBAction func undoButtonTapped() {
        kolodaView?.revertAction()
    }
    
    
    func didHearIDToneWithId(toneId: UInt, iterationIndex: UInt, timestamp: NSTimeInterval) {
        // I am called on a background thread
        // Uncomment me if you would like to receive every iteration of a tone
//        kolodaView.fadeIn()
//        likenessButtonsView.fadeIn()
//        detecterView.fadeOut()
        NSLog("I heard \(iterationIndex) of tone \(toneId)")
    }
    
    func IDToneDidAppearWithId(toneId: UInt, atIteration iterationIndex: UInt, atTimestamp timestamp: NSTimeInterval) {
        
//        dispatch_async(dispatch_get_main_queue()) {
//            let nav = self.window?.rootViewController as! UINavigationController
//            let vc = nav.viewControllers.first as! ViewController
//            vc.setActiveTone(String(toneId))
//        }
        
        NSLog("I am listening to tone \(toneId) \(iterationIndex) \(timestamp)")
    }
    
    func IDToneDidDisappearWithId(toneId: UInt, duration: NSTimeInterval) {
//        dispatch_async(dispatch_get_main_queue()) {
//            let nav = self.window?.rootViewController as! UINavigationController
//            let vc = nav.viewControllers.first as! ViewController
//            vc.setInactive()
//        }
        
        NSLog("Tone \(toneId) ended after \(duration) seconds")
    }
    

}

//MARK: KolodaViewDelegate
extension ViewController: KolodaViewDelegate {
    
    func kolodaDidRunOutOfCards(koloda: KolodaView) {
//        dataSource.insert(UIImage(named: "Card_like_6")!, atIndex: kolodaView.currentCardIndex - 1)
//        let position = kolodaView.currentCardIndex
//        kolodaView.insertCardAtIndexRange(position...position, animated: true)
        kolodaView.resetCurrentCardIndex()
        likenessButtonsView.fadeOut(duration: 0.2)
    }
}

//MARK: KolodaViewDataSource
extension ViewController: KolodaViewDataSource {
    
    func kolodaNumberOfCards(koloda:KolodaView) -> UInt {
        return UInt(imageSource.count)
    }
    
    func koloda(koloda: KolodaView, viewForCardAtIndex index: UInt) -> UIView {
        return UIImageView(image: imageSource[Int(index)])
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

