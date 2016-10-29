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
        static let viewControllerId = String(describing: LoadingViewController.self)
    }
    lazy var loadAnimating = true
    
    @IBOutlet weak var loadingImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.spinLoadingIndicatorWithOptions(UIViewAnimationOptions())

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // moved spinLoadingIndicatorWithOptions from viewDidLoad to viewDidAppear
        self.spinLoadingIndicatorWithOptions(UIViewAnimationOptions())
    }
    
    fileprivate func spinLoadingIndicatorWithOptions(_ options: UIViewAnimationOptions) {
        
        UIView.animate(withDuration: 0.15, delay: 0, options: options, animations: { () -> Void in
            self.loadingImageView.transform = self.loadingImageView.transform.rotated(by: CGFloat(M_PI / 2))
            }) { (finished) -> Void in
                if finished {
                    if self.loadAnimating {
                        self.spinLoadingIndicatorWithOptions([.curveLinear])
                    } else if (options != UIViewAnimationOptions()) {
                        self.spinLoadingIndicatorWithOptions(UIViewAnimationOptions())
                    }
                }
        }
    }
}
