//
//  ViewController.swift
//  PageIndicatorView
//
//  Created by Sergey Zapuhlyak on 07.11.2022.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var pageIndicatorView: PageIndicatorView!
    
    lazy var scrollView = UIScrollView()
    var isScrollViewConfigured: Bool = false
    
    private let numberOfPages = 7
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.insertSubview(scrollView, at: 0)
        pageIndicatorView.apply(model: .default(numberOfPages: numberOfPages,
                                                currentPage: 0))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if isScrollViewConfigured {
            return
        }
        
        setupScrollView()
    }

    private func setupScrollView() {
        let width = view.bounds.width
        let height = view.bounds.height
        let count = numberOfPages
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        scrollView.frame = CGRect(x: 0, y: 0, width: width, height: height)
        scrollView.contentSize = CGSize(width: width * CGFloat(count), height: height)
        
        var previusColor: UIColor? = .white
        for index in 0..<count {
            let view = UIView()
            
            var color: UIColor? = .white
            repeat {
                color = [.red, .yellow, .orange, .cyan, .green, .blue, .magenta, .purple, .brown].randomElement()
                
            } while previusColor == color
                        
            view.backgroundColor = color
            previusColor = color
            view.frame = CGRect(x: CGFloat(index) * width, y: 0, width: width, height: height)
            scrollView.addSubview(view)
        }
        isScrollViewConfigured = true
    }
}

extension ViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let currentPage = scrollView.contentOffset.x / scrollView.frame.size.width
        
        pageIndicatorView.apply(model: .default(numberOfPages: numberOfPages,
                                                currentPage: currentPage))
    }
}
