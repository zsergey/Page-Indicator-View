# 🫥 Page Indicator View

> A view that displays a horizontal series of dots, each of which corresponds to a page in the app’s document or other data-model entity. The current dot has an elongated shape. Please feel free to use the page indicator view and give it a star if you find it useful.
>

### 🛠 Usage

```swift
let numberOfPages = 7

pageIndicatorView.apply(model: .default(numberOfPages: numberOfPages,
                                        currentPage: 0))

extension ViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let currentPage = scrollView.contentOffset.x / scrollView.frame.size.width
        
        pageIndicatorView.apply(model: .default(numberOfPages: numberOfPages,
                                                currentPage: currentPage))
    }
}

```
### 🏝️ Example

<img src="https://github.com/zsergey/page-indicator-view/blob/develop/example.gif" height="600" width="278">

