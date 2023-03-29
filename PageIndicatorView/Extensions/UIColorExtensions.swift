//
//  UIColorExtensions.swift
//  PageIndicatorView
//
//  Created by Sergey Zapuhlyak on 10.11.2022.
//

import UIKit

extension UIColor {
    
    func translated(to color: UIColor, percentage: CGFloat) -> UIColor {
        toColor(color, progress: percentage)
    }
    
    func toColor(_ finalColor: UIColor, progress: CGFloat) -> UIColor {
        
        var finalRed: CGFloat = 0
        var finalGreen: CGFloat = 0
        var finalBlue: CGFloat = 0
        finalColor.getRed(&finalRed, green: &finalGreen, blue: &finalBlue, alpha: nil)
        
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: nil)
        
        let newRed   = (1.0 - progress) * red   + progress * finalRed
        let newGreen = (1.0 - progress) * green + progress * finalGreen
        let newBlue  = (1.0 - progress) * blue  + progress * finalBlue
        
        return UIColor(red: newRed, green: newGreen, blue: newBlue, alpha: 1.0)
    }
}
