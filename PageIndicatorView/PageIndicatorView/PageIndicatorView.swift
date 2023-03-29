//
//  PageIndicatorView.swift
//  PageIndicatorView
//
//  Created by Sergey Zapuhlyak on 10.11.2022.
//

import UIKit

public final class PageIndicatorView: BaseView {

    // MARK: - Views

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .clear
        scrollView.isUserInteractionEnabled = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    private var dotLayers: [CALayer] = []
    
    // MARK: - Private properties

    private var currentPageIndicatorTintColor: UIColor = .white
    private var pageIndicatorTintColor: UIColor = .black
    private var numberOfPages: Int = 0
    private var currentPage: CGFloat = 0

    private lazy var lineWidth: CGFloat = 6
    private lazy var radius = lineWidth / 2
    private let maxPages = 5
    private let numberOfFixedPages = 2
    private lazy var dashLength: CGFloat = 9
    private lazy var gap: CGFloat = 11

    public override func setup() {

        addSubview(scrollView)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        setupScrollView()
        layoutDotLayers()
        updateContentOffset()
    }
    
    public func apply(model: PageIndicatorViewModel) {
        numberOfPages = model.numberOfPages
        currentPage = model.currentPage
        currentPageIndicatorTintColor = model.currentPageIndicatorTintColor
        pageIndicatorTintColor = model.pageIndicatorTintColor

        addDotLayers()
        layoutDotLayers()
        updateContentOffset()
    }
    
    private func setupScrollView() {
        scrollView.contentSize = CGSize(width: dashLength + CGFloat(numberOfPages - 1) * gap,
                                        height: bounds.height)
        
        let width = dashLength + CGFloat(min(maxPages, numberOfPages)) * gap + gap - lineWidth
        scrollView.frame = CGRect(x: (bounds.width - width) / 2,
                                  y: 0,
                                  width: width,
                                  height: bounds.height)
    }
    
    private func layoutDotLayers() {
        var point = CGPoint(x: gap - lineWidth / 2, y: bounds.height / 2)
        
        let roundedCurrentPage = Int(currentPage)
        let firstScale = CGFloat(roundedCurrentPage) - currentPage + 1
        let firstColorScale = roundedCurrentPage == numberOfPages - 1 ? 1 : firstScale

        let secondScale = max(currentPage - CGFloat(roundedCurrentPage), 0)
        
        for index in 0..<numberOfPages {
            let layer = dotLayers[index]
            
            if index == roundedCurrentPage {

                point = layer.makeAsDash(centerAt: point, radius: radius, length: dashLength * firstScale)
                layer.backgroundColor = fetchCurrentPageIndicatorTintColor(percentage: firstColorScale)
                
            } else if index == roundedCurrentPage + 1 {

                point = layer.makeAsDash(centerAt: point, radius: radius, length: dashLength * secondScale)
                layer.backgroundColor = fetchCurrentPageIndicatorTintColor(percentage: secondScale)
                
            } else {
                
                scaleDotLayer(layer, at: index, point: point)
                layer.backgroundColor = fetchPageIndicatorTintColor()
            }
            
            point = CGPoint(x: point.x + gap, y: point.y)
        }
    }
    
    private func scaleDotLayer(_ layer: CALayer, at index: Int, point: CGPoint) {

        guard numberOfPages > maxPages else {
            layer.makeAsCircle(centerAt: point, radius: radius)
            return
        }
        
        let maxValue: CGFloat = 2
        
        if currentPage > CGFloat(numberOfFixedPages - 1),
           CGFloat(index) < currentPage {
            
            let currentPage = min(currentPage, CGFloat(numberOfPages - numberOfFixedPages - 1))
            let countDroppedIndexes = currentPage - CGFloat(numberOfFixedPages)
            let value = min(CGFloat(index + 1) - countDroppedIndexes, maxValue)
            let scale = value / maxValue
            
            layer.makeAsCircle(centerAt: point, radius: radius * scale)
            
        } else {
            
            let currentPage = currentPage < maxValue ? currentPage + (maxValue - currentPage) : currentPage
            let value = max(min(currentPage + maxValue - CGFloat(index) + 1, maxValue), 0)
            let scale = value / maxValue
            
            layer.makeAsCircle(centerAt: point, radius: radius * scale)
            
        }
    }
    
    private func fetchPageIndicatorTintColor() -> CGColor {
        pageIndicatorTintColor.resolvedColor(with: traitCollection).cgColor
    }
    
    private func fetchCurrentPageIndicatorTintColor(percentage: CGFloat) -> CGColor {
        let pageIndicatorTintColor = pageIndicatorTintColor.resolvedColor(with: traitCollection)
        let currentPageIndicatorTintColor = currentPageIndicatorTintColor.resolvedColor(with: traitCollection)
        return pageIndicatorTintColor.translated(to: currentPageIndicatorTintColor, percentage: percentage).cgColor
    }
    
    private func addDotLayers() {
        dotLayers.forEach {
            $0.removeFromSuperlayer()
        }
        dotLayers = []
        
        (0..<numberOfPages).forEach { _ in
            let layer = CALayer()
            layer.cornerRadius = radius
            layer.backgroundColor = fetchPageIndicatorTintColor()
            scrollView.layer.addSublayer(layer)
            dotLayers.append(layer)
        }
    }
    
    func updateContentOffset() {

        if numberOfPages > maxPages {
            if currentPage < CGFloat(numberOfFixedPages) {
                scrollView.contentOffset = .zero
            } else if currentPage < CGFloat(numberOfPages - (maxPages - numberOfFixedPages)) {
                let x = gap * (currentPage - CGFloat(numberOfFixedPages))
                scrollView.contentOffset = CGPoint(x: x, y: .zero)
            } else {
                let x = gap * CGFloat(numberOfPages - maxPages)
                scrollView.contentOffset = CGPoint(x: x, y: .zero)
            }
        } else {
            scrollView.contentOffset = .zero
        }
    }
}

fileprivate extension CALayer {
    
    func makeAsCircle(centerAt point: CGPoint, radius: CGFloat) {
        frame = CGRect(x: point.x - radius,
                       y: point.y - radius,
                       width: radius * 2,
                       height: radius * 2)
        cornerRadius = radius
    }
    
    func makeAsDash(centerAt point: CGPoint, radius: CGFloat, length: CGFloat) -> CGPoint {
        frame = CGRect(x: point.x - radius,
                       y: point.y - radius,
                       width: radius * 2 + length,
                       height: radius * 2)
        return CGPoint(x: point.x + length, y: point.y)
    }
}
