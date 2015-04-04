//
//  ViewController.swift
//  EMNotice
//
//  Created by Emad A. on 26/03/2015.
//  Copyright (c) 2015 Emad A. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var textField: UITextField?
    @IBOutlet var secLabel: UILabel?
    @IBOutlet var slider: UISlider?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prefersStatusBarHidden() -> Bool {
        return false
    }

    // MARK:

    @IBAction func durationValueChanded(sender: UISlider) {
        secLabel?.text = "\(Int(floor(sender.value))) Sec"
    }

    @IBAction func addNotice(sender: UIButton) {
        let notice: EMNoticeView = EMNoticeView(duration: NSTimeInterval(floor(slider!.value)))
        notice.textLabel.text = textField?.text

        if sender.tag == 10 {
            notice.backgroundColor = EMNoticeType.Success.toColor()
            notice.imageView.image = UIImage(named: "success")
        }
        else if sender.tag == 20 {
            notice.backgroundColor = EMNoticeType.Info.toColor()
            notice.imageView.image = UIImage(named: "info")
        }
        else if sender.tag == 30 {
            notice.backgroundColor = EMNoticeType.Warning.toColor()
            notice.imageView.image = UIImage(named: "warning")
        }
        else if sender.tag == 40 {
            notice.backgroundColor = EMNoticeType.Error.toColor()
            notice.imageView.image = UIImage(named: "error")
        }

        EMNoticeCenter.defaultCenter().addNotice(notice)
    }

    @IBAction func fire() {
        EMNoticeCenter.defaultCenter().fire()
    }
}

extension ViewController: UITextFieldDelegate {

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}

