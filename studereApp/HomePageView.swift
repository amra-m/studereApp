import CoreData
import SwiftUI


// Task block apperance
struct TaskBlockView: View {
    let task: Task
    let onDelete: () -> Void

    var body: some View {
        VStack(alignment: .leading) {
            Text(task.title)
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(task.description)
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.8))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
            
            HStack{
                Spacer()
                Button(action: onDelete){
                    Image(systemName: "trash")
                        .foregroundColor(.white)
                }
            }
        }
        
        .padding()
        .frame(height: 100)
        .frame(width: 350)
        .background(task.category.color)
        .foregroundColor(.white)
        .cornerRadius(10)
    }
}

struct HomePageView: View {
    @State private var currentDate = Date()
    @State private var selectedDate = Date()
    @State private var selectedDay = Date()
    @State private var tasks: [Task] = []
    @State private var showingAddTask = false
    @State private var showingTimerView = false
    
    
    private var isCurrentDay: (Int) -> Bool {
        return { dayOffset in
            let calendar = Calendar.current
            guard let weekStart = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: selectedDate)) else { return false }
            guard let specificDay = calendar.date(byAdding: .day, value: dayOffset, to: weekStart) else { return false }
            return calendar.isDateInToday(specificDay)
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        
                        // Date text
                        Spacer()
                        Text(getCurrentDate())
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .padding(.horizontal, 10)
                        
                        // Welcome Text
                        Text(" Welcome back 📚")
                            .font(.system(size: 40))
                            .foregroundColor(.black)
                        
                        // Week calendar
                        // Elements of this component were enhanced with AI Assistance, for example the ScrollView with a horizontal access, as well as the ForEach and handling user interactions. 
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 20) {
                                ForEach(0..<7, id: \.self) { index in
                                    Text(getDayOfWeek(dayOffset: index))
                                        .frame(width: 60, height: 50)
                                        .background(selectedDay == getDateForIndex(index) ? Color.blue : Color.gray.opacity(0.2))
                                                                                .foregroundColor(selectedDay == getDateForIndex(index) ? .white : .black)
                                                                                .cornerRadius(10)
                                                                                .onTapGesture {
                                                                                    withAnimation(.easeInOut(duration: 0.1)) {
                                                                                        selectedDate = getDateForIndex(index)
                                                                                        selectedDay = getDateForIndex(index)
                                            }
                                        }
                                }
                            }
                        }
                        


                        
                        // Task blocks
                        ScrollView(.horizontal, showsIndicators: false) {
                            VStack(spacing: 20) {
                                ForEach(tasks.filter { task in
                                    Calendar.current.isDate(task.date, inSameDayAs: selectedDate)
                                }) { task in
                                    TaskBlockView(task: task, onDelete: {
                                        deleteTask(task)
                                    })
                                }
                            }
                            .padding()
                        }
                    }
                }
                VStack {
                    HStack {
                        Spacer()
                        
                    }
                    
                    .padding(.bottom, 10)
                    
                    HStack {
                        
                        // Home Button
                        Button {

                        } label: {
                            Image(systemName: "house.fill")
                                .imageScale(.large)
                                .foregroundColor(.blue)
                        }
                        
                        Spacer()
                        
                        // Plus Button
                        Button(action:{
                            showingAddTask = true
                        }) {
                            Image(systemName: "plus")
                                .font(.system(size: 30))
                                .imageScale(.large)
                                .bold()
                                .frame(width: 70, height: 70)
                                .background(.purple)
                                .foregroundColor(.white)
                                .clipShape(Circle())
                        }
                        .padding(.horizontal, 65)
                        .sheet(isPresented: $showingAddTask){
                            AddTaskView(onAdd: { newTask in tasks.append(newTask)
                                
                            })
                        }
                        
                        
                        // Timer Button
                        Button {
                            showingTimerView = true
                        } label: {
                            Image(systemName: "clock.fill")
                                .imageScale(.large)
                        }
                        .sheet(isPresented: $showingTimerView){
                            TimerViewControllerRepresentable()
                        }
                        
                                                
                    }
                    .padding(.horizontal, 65)
                }
                .background(Color.clear)
            }
            .onAppear(perform: {
                UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert]) { (_, _) in
                }
            })
            .foregroundColor(.gray)
            .background(Color("Background"))
        }
        
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        
    }
    // Current date
    func getCurrentDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d, yyyy"
        return dateFormatter.string(from: selectedDate)
    }
    
    // Day of week
    func getDayOfWeek(dayOffset: Int) -> String {
        let calendar = Calendar.current
        guard let weekStart = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: selectedDate)) else { return "" }
        guard let specificDay = calendar.date(byAdding: .day, value: dayOffset, to: weekStart) else { return "" }
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "EEE"
        return dayFormatter.string(from: specificDay)
    }
    
    // Index
    func getDateForIndex(_ index: Int) -> Date{
        let calendar = Calendar.current
        let weekStart = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: currentDate))!
        return calendar.date(byAdding: .day, value: index, to: weekStart)!
    }
    
    func deleteTask(_ task: Task){
        if let index = tasks.firstIndex(where: { $0.id == task.id}){
            tasks.remove(at: index)
        }
    }
}

struct Previews_HomePageView_Previews: PreviewProvider {
    static var previews: some View {
        HomePageView()
    }
}
