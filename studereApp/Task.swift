import Foundation

struct Task: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let category: TaskCategory
    let date: Date
}
