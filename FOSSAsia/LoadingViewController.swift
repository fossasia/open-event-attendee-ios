//
//  LoadingViewController.swift
//  FOSSAsia
//
//  Created by Jurvis Tan on 12/2/16.
//  Copyright © 2016 FossAsia. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {
    struct StoryboardConstants {
        static let storyboardName = "Sessions"
        static let viewControllerId = String(LoadingViewController)
    }
    lazy var loadAnimating = true
    
    @IBOutlet weak var loadingImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.spinLoadingIndicatorWithOptions([.CurveEaseInOut])

    }
    
    private func spinLoadingIndicatorWithOptions(options: UIViewAnimationOptions) {
        
        UIView.animateWithDuration(0.15, delay: 0, options: options, animations: { () -> Void in
            self.loadingImageView.transform = CGAffineTransformRotate(self.loadingImageView.transform, CGFloat(M_PI / 2))
            }) { (finished) -> Void in
                if finished {
                    if self.loadAnimating {
                        self.spinLoadingIndicatorWithOptions([.CurveLinear])
                    } else if (options != [.CurveEaseInOut]) {
                        self.spinLoadingIndicatorWithOptions([.CurveEaseInOut])
                    }
                }
        }
    }
}
