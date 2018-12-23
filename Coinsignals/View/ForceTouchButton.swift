//
//  ForceTouchButton.swift
//  Coinsignals
//
//  Created by Julian Praest on 12/23/18.
//  Copyright © 2018 Org. All rights reserved.
//

import UIKit
import AudioToolbox

class ForceTouchButton: UIButton {

        var allowTouchAnimation: Bool = true
    
        var is3DTouchAvailable: Bool {
            return self.traitCollection.forceTouchCapability == .available
        }
        
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            super.touchesBegan(touches, with: event)
            if allowTouchAnimation {
                if is3DTouchAvailable == false {
                    UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: {
                        self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                    }, completion: ({_ in
                    }))
                }
            }
        }
        
        override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
            super.touchesEnded(touches, with: event)
            if allowTouchAnimation {
                UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseInOut, animations: {
                    self.transform = CGAffineTransform.identity
                }, completion: ({_ in
                }))
            }
        }
        
        override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
            super.touchesEnded(touches, with: event)
            if allowTouchAnimation {
                UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseInOut, animations: {
                    self.transform = CGAffineTransform.identity
                }, completion: ({_ in
                }))
            }
        }
        
        override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
            super.touchesMoved(touches, with: event)
            if allowTouchAnimation {
                if let touch = touches.first {
                    guard is3DTouchAvailable else {return}
                    
                    let maximumForce = touch.maximumPossibleForce
                    let force = touch.force
                    let normalizedForce = (force / maximumForce) / 10;
                    
                    print("normalizedForce : \(normalizedForce)")
                    
                    self.transform = CGAffineTransform(scaleX: 1 - normalizedForce, y: 1 - normalizedForce)
                    
                }
            }
        }
    
    
        
}

