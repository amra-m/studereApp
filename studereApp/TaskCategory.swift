import Foundation
import SwiftUI

enum TaskCategory: String, CaseIterable{
    case assignment = "Assignment"
    case test = "Test"
    case studySession = "Study Session"
    case lecture = "Lecture"
    case other = "Other"
    
    var title: String{
        return self.rawValue
    }
    
    var color: Color{
        switch self{
        case .assignment:
            return Color.pink
        case .test:
            return Color.red
        case .studySession:
            return Color.green
        case .lecture:
            return Color.blue
        case .other:
            return Color.gray
        }
    }
}
