import UIKit
import SwiftUI

class HomePageViewController: UIHostingController<HomePageView> {
    required init?(coder: NSCoder) {
        super.init(coder: coder, rootView: HomePageView())
    }
}
