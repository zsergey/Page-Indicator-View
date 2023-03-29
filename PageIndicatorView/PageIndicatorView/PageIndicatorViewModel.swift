//
//  PageIndicatorViewModel.swift
//  PageIndicatorView
//
//  Created by Sergey Zapuhlyak on 10.11.2022.
//

import UIKit

public struct PageIndicatorViewModel {
    
    let numberOfPages: Int
    let currentPage: CGFloat
    let currentPageIndicatorTintColor: UIColor
    let pageIndicatorTintColor: UIColor
}

extension PageIndicatorViewModel {
    
    public static func `default`(numberOfPages: Int,
                                 currentPage: CGFloat) -> Self {
        
        Self(numberOfPages: numberOfPages,
             currentPage: currentPage,
             currentPageIndicatorTintColor: .white,
             pageIndicatorTintColor: .black)
    }
}
