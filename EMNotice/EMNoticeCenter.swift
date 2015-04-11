//
//  EMNoticeCenter.swift
//  EMNotice
//
//  Created by Emad A. on 26/03/2015.
//  Copyright (c) 2015 Emad A. All rights reserved.
//

import UIKit

class EMNoticeCenter: NSObject {

    // MARK: Private Properties

    // The queue of notice views
    private var queue = [EMNoticeView]()

    // The timer to dismiss current notice view
    private var timer: NSTimer?

    // The window that contains notice views
    private var window: EMNoticeWindow?

    // MARK:

    class func defaultCenter() -> EMNoticeCenter {
        struct Static {
            static let instance: EMNoticeCenter = EMNoticeCenter()
        }
        return Static.instance
    }

    override init() {
        super.init()
    }

    // MARK: Public Methods

    func addNotice(#duration: NSTimeInterval, type: EMNoticeType, message: String, image: UIImage?) {
        let notice: EMNoticeView = EMNoticeView(duration: duration)
        notice.backgroundColor = type.toColor()
        notice.textLabel.text = message
        notice.imageView.image = image

        addNotice(notice)
    }

    func addNotice(notice: EMNoticeView) {
        queue.append(notice)
    }

    func fire() {
        prepareToFire()
        if window?.hidden == true && queue.count > 0 {
            presentNotice(queue.removeAtIndex(0))
        }
    }

    func fireNotice(#duration: NSTimeInterval, type: EMNoticeType, message: String, image: UIImage?) {
        addNotice(duration: duration, type: type, message: message, image: image)
        fire()
    }

    // MARK: - Private Methods

    private func prepareToFire() {
        if self.window == nil {
            self.window = EMNoticeWindow(frame: UIScreen.mainScreen().bounds)
            self.window?.rootViewController = EMNoticeViewController()
            self.window?.backgroundColor = UIColor.clearColor()
            self.window?.windowLevel = UIWindowLevelAlert
        }
    }

    private func presentNotice(notice: EMNoticeView) {
        notice.frame = CGRect(origin: CGPointZero, size: notice.sizeThatFits(window?.bounds.size ?? CGSizeZero))
        notice.transform = CGAffineTransformMakeTranslation(0, notice.bounds.height * -1)
        
        let swipe: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: Selector("gestureHandler:"))
        swipe.direction = UISwipeGestureRecognizerDirection.Up
        notice.addGestureRecognizer(swipe)

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("gestureHandler:"))
        notice.addGestureRecognizer(tap)

        window?.rootViewController?.view.addSubview(notice)
        window?.hidden = false

        UIView.animateWithDuration(
            0.35,
            delay: 0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 1,
            options: UIViewAnimationOptions.CurveEaseInOut,
            animations: {
                notice.transform = CGAffineTransformMakeTranslation(0, 0)
            },
            completion: {
                (value: Bool) in
                self.timer?.invalidate()
                self.timer = NSTimer.schedule(notice.duration) { timer in
                    self.dismissNotice(notice)
                }
            }
        )
    }

    private func dismissNotice(notice: EMNoticeView) {
        if let recognizers = notice.gestureRecognizers {
            for recognizer in recognizers {
                notice.removeGestureRecognizer(recognizer as! UIGestureRecognizer)
            }
        }

        UIView.animateWithDuration(
            0.25,
            delay: 0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 1,
            options: UIViewAnimationOptions.CurveEaseInOut,
            animations: {
                notice.transform = CGAffineTransformMakeTranslation(0, notice.bounds.height * -1)
            },
            completion: { (Bool) in
                notice.removeFromSuperview()
                if self.queue.count > 0 {
                    self.presentNotice(self.queue.removeAtIndex(0))
                }
                else {
                    self.window?.hidden = true
                    self.window = nil
                }
            }
        )
    }

    dynamic private func gestureHandler(recognizer: UIGestureRecognizer) {
        if let notice = recognizer.view as? EMNoticeView {
            dismissNotice(notice)
        }
    }
}

// MARK: - EMNoticeWindow
// MARK:

private class EMNoticeWindow: UIWindow {

    private override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        var hitTest: UIView? = nil;
        // Grabbing the event if it happenes on subviews
        for subview in rootViewController?.view.subviews as! [UIView] {
            if CGRectContainsPoint(subview.frame, point) == true {
                hitTest = super.hitTest(point, withEvent: event)
                break;
            }
        }

        return hitTest
    }
}

// MARK: - EMNoticeViewController
// MARK:

private class EMNoticeViewController: UIViewController {

    private override func prefersStatusBarHidden() -> Bool {
        return UIApplication.sharedApplication().statusBarHidden
    }

    private override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)

        for subview in view.subviews {
            if let notice = subview as? EMNoticeView {
                notice.frame = CGRect(origin: CGPointZero, size: notice.sizeThatFits(size))
            }
        }
    }
}

// MARK: - NSTimer Extension
// MARK:

extension NSTimer {

    class func schedule(delay: NSTimeInterval, handler: NSTimer! -> Void) -> NSTimer {
        let timer = CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, delay + CFAbsoluteTimeGetCurrent(), 0, 0, 0, handler)
        CFRunLoopAddTimer(CFRunLoopGetCurrent(), timer, kCFRunLoopCommonModes)

        return timer
    }
}
