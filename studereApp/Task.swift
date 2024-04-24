import Foundation

struct Task: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let category: TaskCategory
    let date: Date
}

/*// Sample task data
let sampleTasks: [Task] = [
    Task(title: "Task 1", description: "This is the first task.", date: Date()),
    Task(title: "Task 2", description: "This is the second task.", date: Date().addingTimeInterval(86400)),
    Task(title: "Task 3", description: "This is the third task.", date: Date().addingTimeInterval(172800)),
    Task(title: "Task 4", description: "This is the fourth task.", date: Date().addingTimeInterval(259200)),
    Task(title: "Task 5", description: "This is the fifth task.", date: Date().addingTimeInterval(345600))
]*/
