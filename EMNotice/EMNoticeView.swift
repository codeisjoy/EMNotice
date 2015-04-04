//
//  EMNoticeView.swift
//  EMNotice
//
//  Created by Emad A. on 28/03/2015.
//  Copyright (c) 2015 Emad A. All rights reserved.
//

import UIKit

// MARK: - EMNoticeView Type Colours
// MARK:

enum EMNoticeType: Int {
    case Success, Info, Warning, Error
    func toColor() -> UIColor {
        switch self {
        case .Success: return UIColor(red:0.46, green:0.71, blue:0.29, alpha:1)
        case .Info:    return UIColor(red:0.26, green:0.66, blue:0.88, alpha:1)
        case .Warning: return UIColor(red:0.95, green:0.62, blue:0.13, alpha:1)
        case .Error:   return UIColor(red:0.88, green:0.26, blue:0.26, alpha:1)
        }
    }
}

// MARK: - EMNoticeView
// MARK:

class EMNoticeView: UIView {

    // MARK: - Public Properties

    // The appearance duration of view
    var duration: NSTimeInterval = 4.0

    var textEdgeInset:  UIEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    var imageEdgeInset: UIEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)

    // To use UIAppearance protocol to set text font
    dynamic var textFont: UIFont {
        get { return textLabel.font }
        set { textLabel.font = newValue }
    }

    // To use UIAppearance protocol to set text color
    dynamic var textColor: UIColor {
        get { return textLabel.textColor }
        set { textLabel.textColor = newValue }
    }

    // To use UIAppearance protocol to set text alignment
    dynamic var textAlignment: NSTextAlignment {
        get { return textLabel.textAlignment }
        set { textLabel.textAlignment = newValue }
    }

    // Text label that shown the notice message
    private(set) lazy var textLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textColor = UIColor.whiteColor()
        label.font = UIFont.systemFontOfSize(14)
        label.backgroundColor = UIColor.clearColor()
        label.numberOfLines = 0

        return label
        }()

    // Image view that shown notice image
    private(set) lazy var imageView: UIImageView = {
        let view: UIImageView = UIImageView()
        view.contentMode = .Center
        view.backgroundColor = UIColor.clearColor()

        return view
        }()

    // MARK: - Private Properties

    private var minHeight: CGFloat {
        let statusBarHeight: CGFloat = UIApplication.sharedApplication().statusBarFrame.size.height
        if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Phone &&
           UIScreen.mainScreen().nativeBounds.height / UIScreen.mainScreen().nativeScale < 736 &&
           UIDeviceOrientationIsLandscape(UIDevice.currentDevice().orientation)
        {
            return statusBarHeight + 32
        }
        return statusBarHeight + 44
    }

    // MARK: - Overriden Methods

    override init() {
        super.init()
        backgroundColor = EMNoticeType.Error.toColor()
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    convenience init(duration: NSTimeInterval) {
        self.init()
        self.duration = duration
    }
    
    override func willMoveToSuperview(newSuperview: UIView?) {
        super.willMoveToSuperview(newSuperview)
        if newSuperview != nil {
            addSubview(imageView)
            addSubview(textLabel)
        }
        else {
            imageView.removeFromSuperview()
            textLabel.removeFromSuperview()
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        // Proper rect to layout subviews
        let b: CGRect = CGRect(
            origin: CGPointZero,
            size: sizeThatFits(CGSize(width: superview?.bounds.width ?? 0, height: CGFloat.max)))

        // Position image view
        imageView.frame = CGRectZero
        if imageView.image != nil {
            imageView.frame = CGRect(
                origin: CGPoint(x: CGRectGetMinX(bounds) + imageEdgeInset.left, y: CGRectGetMinY(bounds) + imageEdgeInset.top),
                size: CGSize(width: imageView.image?.size.width ?? 0, height: b.height - imageEdgeInset.top - imageEdgeInset.bottom))
        }

        // Position text label
        textLabel.frame = CGRectZero
        if textLabel.text != nil {
            let textLabelOrigin: CGPoint = CGPoint(
                x: CGRectGetMaxX(imageView.frame) + imageEdgeInset.right + textEdgeInset.left,
                y: CGRectGetMinY(bounds) + textEdgeInset.top)
            let textLabelFitSize: CGSize = CGSize(
                width: b.width - textLabelOrigin.x - textEdgeInset.right,
                height: b.height - textEdgeInset.top - textEdgeInset.bottom)
            textLabel.frame = CGRect(origin: textLabelOrigin, size: textLabelFitSize)
        }
    }

    
    override func sizeThatFits(size: CGSize) -> CGSize {
        let txtOffset: CGFloat = textEdgeInset.left + textEdgeInset.right

        // The size of image view that fits
        var imageViewFitSize: CGSize = CGSizeZero
        if imageView.image != nil {
            imageViewFitSize = CGSize(
                width: imageEdgeInset.left + imageEdgeInset.right + (imageView.image?.size.width ?? 0),
                height: imageEdgeInset.top + imageEdgeInset.bottom + (imageView.image?.size.height ?? 0))
        }

        // The size of text label that fits
        var textLabelFitSize: CGSize = CGSizeZero
        if textLabel.text != nil {
            textLabelFitSize = textLabel.sizeThatFits(CGSize(width: size.width - imageViewFitSize.width - txtOffset, height: CGFloat.max))
            textLabelFitSize.height += textEdgeInset.top + textEdgeInset.bottom
            textLabelFitSize.width += txtOffset;
        }

        let maxSubviewsHeight: CGFloat = max(imageViewFitSize.height, textLabelFitSize.height)
        let maxPossibleHeight: CGFloat = max(maxSubviewsHeight, minHeight)

        var output: CGSize = size
        output.height = min(maxPossibleHeight, output.height)
        
        return output
    }
}