import UIKit
import SwiftUI

class TimerHostingController: UIHostingController<TimerView> {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder, rootView: TimerView())
    }
}
