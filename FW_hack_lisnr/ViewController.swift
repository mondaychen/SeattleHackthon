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

    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        sharedData.urlToLoad = (direction == SwipeResultDirection.Left) ? "https://google.com" : "http://freewheel.tv"
        
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

