import SwiftUI

struct AddTaskView: View {
    // Add task button call
    var onAdd: (Task)->()
    
    @Environment(\.dismiss) private var dismiss
    @State private var taskTitle: String = ""
    @State private var taskDescription: String = ""
    @State private var selectedCategory: TaskCategory = .assignment
    @State private var taskDate = Date()


    
    var body: some View{
        NavigationView{
            VStack(alignment: .leading){
                
                // Back button
                Button(action: {
                    dismiss()
                }, label: {
                    HStack{
                        Image(systemName: "chevron.left")
                            .foregroundColor(.black)
                            .imageScale(.large)
                        //Text("Back")
                            .foregroundColor(.black)
                    }
                    .padding()
                })
                .frame(maxWidth: .infinity, alignment:. leading)
                
                
                // Task title
                Text("Create a new task")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
                TextField("Enter task title", text: $taskTitle)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .background(Color(.systemGroupedBackground))
                    .cornerRadius(10)
                    .shadow(color: .gray.opacity(0.5), radius: 5)
                    
                
                // Description
                Text("\nDescription")
                    .font(.headline)
                    .padding(.leading)
                               
                TextEditor(text: $taskDescription)
                    .frame(height: 100)
                    .padding()
                    .background(Color(.systemGroupedBackground))
                    .cornerRadius(10)
                    .shadow(color: .gray.opacity(0.5), radius: 5)
                
                    
                    //Category
               Text("\nCategory")
                    .font(.headline)
                    .padding(.leading)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(TaskCategory.allCases, id: \.self) { category in
                            Button(action: {
                                selectedCategory = category
                            }) {
                                Text(category.title)
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(minWidth: 100) // Ensuring minimum width
                                    .background(category.color)
                                    .cornerRadius(8)
                            }
                        }
                    }
                }
                .padding(.vertical)
                
                
                DatePicker("Select Date", selection: $taskDate, in: Date()..., displayedComponents: .date)
                    .padding()
                    .datePickerStyle(CompactDatePickerStyle())
                
                Spacer()
                
                // Save button
                Button(action: {
                    let newTask = Task(title: taskTitle, description: taskDescription, category: selectedCategory, date: taskDate)
                    onAdd(newTask)
                    dismiss()
                }, label: {
                    Text("Save Task")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.gray)
                        .cornerRadius(10)
                })
                .padding()
                
                

            }
        }
    }
    
    struct AddTaskView_Previews: PreviewProvider {
        static var previews: some View {
            AddTaskView{
                task in
            }
        }
    }
}
