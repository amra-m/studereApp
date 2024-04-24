import SwiftUI
import UserNotifications

struct ContentView: View {
    var body: some View {
        NavigationView {
            Home()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct PreviousView: View {
    var body: some View {
        Text("Previous View")
    }
}

struct Home: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State var start = false
    @State var to: CGFloat = 0
    @State var count = 0
    @State var time = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var selectedHours = 0
    @State var selectedMinutes = 0
    @State var selectedSeconds = 0
    
    let hours = Array(0...23)
    let minutes = Array(0...59)
    let seconds = Array(0...59)
    
    var totalDuration: Int {
        return selectedHours * 3600 + selectedMinutes * 60 + selectedSeconds
    }
    
    var selectedDurationString: String {
        let hours = selectedHours < 5 ? "0\(selectedHours)" : "\(selectedHours)"
        let minutes = selectedMinutes < 5 ? "0\(selectedMinutes)" : "\(selectedMinutes)"
        let seconds = selectedSeconds < 5 ? "0\(selectedSeconds)" : "\(selectedSeconds)"
        return "\(hours):\(minutes):\(seconds)"
    }
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.06).edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.black)
                            .font(.title)
                    }
                    
                    Spacer()
                }
                .padding()
                
                Spacer()
                
                ZStack {
                    Circle()
                        .trim(from: 0, to: 1)
                        .stroke(Color.black.opacity(0.09), style: StrokeStyle(lineWidth: 40, lineCap: .round))
                        .frame(width: 320, height: 320)
                    
                    Circle()
                        .trim(from: 0, to: self.to)
                        .stroke(Color.purple, style: StrokeStyle(lineWidth: 40, lineCap: .round))
                        .frame(width: 320, height: 320)
                        .rotationEffect(.init(degrees: -90))
                    
                    VStack {
                        Text(formattedTime(seconds: self.count))
                            .font(.system(size: 50))
                            .fontWeight(.bold)
                    }
                }
                
                HStack {
                    VStack {
                        Text(" ")
                        Text(" ")
                        Text("Hours")
                            .font(.headline)
                        
                        Picker("Hours", selection: self.$selectedHours) {
                            ForEach(hours, id: \.self) { hour in
                                Text("\(hour)")
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .frame(width: 80, height: 100)
                        .clipped()
                    }
                    
                    VStack {
                        Text(" ")
                        Text(" ")
                        Text("Minutes")
                            .font(.headline)
                        
                        Picker("Minutes", selection: self.$selectedMinutes) {
                            ForEach(minutes, id: \.self) { minute in
                                Text("\(minute)")
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .frame(width: 80, height: 100)
                        .clipped()
                    }
                    
                    VStack {
                        Text(" ")
                        Text(" ")
                        Text("Seconds")
                            .font(.headline)
                        
                        Picker("Seconds", selection: self.$selectedSeconds) {
                            ForEach(seconds, id: \.self) { second in
                                Text("\(second)")
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .frame(width: 80, height: 100)
                        .clipped()
                    }
                }
                
                HStack(spacing: 20) {
                    Button(action: {
                        if self.count == self.totalDuration {
                            self.count = 0
                            withAnimation(.default) {
                                self.to = 0
                            }
                        }
                        self.start.toggle()
                    }) {
                        HStack(spacing: 15) {
                            Image(systemName: self.start ? "pause.fill" : "play.fill")
                                .foregroundColor(.white)
                            
                            Text(self.start ? "Pause" : "Play")
                                .foregroundColor(.white)
                        }
                        .padding(.vertical)
                        .frame(width: (UIScreen.main.bounds.width / 2) - 55)
                        .background(Color.purple)
                        .clipShape(Capsule())
                        .shadow(radius: 6)
                    }
                    
                    Button(action: {
                        self.count = 0
                        withAnimation(.default) {
                            self.to = 0
                        }
                    }) {
                        HStack(spacing: 15) {
                            Image(systemName: "arrow.clockwise")
                                .foregroundColor(.purple)
                            
                            Text("Restart")
                                .foregroundColor(.purple)
                        }
                        .padding(.vertical)
                        .frame(width: (UIScreen.main.bounds.width / 2) - 55)
                        .background(
                            Capsule()
                                .stroke(Color.purple, lineWidth: 2)
                        )
                        .shadow(radius: 6)
                    }
                }
                .padding(.top, 55)
            }
        }
        .onAppear(perform: {
            UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert]) { (_, _) in
            }
        })
        .onReceive(self.time) { (_) in
            if self.start {
                if self.count != self.totalDuration {
                    self.count += 1
                    print("Hi")
                    
                    withAnimation(.default) {
                        self.to = CGFloat(self.count) / CGFloat(self.totalDuration)
                    }
                } else {
                    self.start.toggle()
                    self.Notify()
                }
            }
        }
    }
    
    func formattedTime(seconds: Int) -> String {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        let seconds = (seconds % 3600) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    func Notify() {
        let content = UNMutableNotificationContent()
        content.title = "Studere"
        content.body = "Timer is complete."
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        
        let req = UNNotificationRequest(identifier: "MSG", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(req, withCompletionHandler: nil)
    }
}

struct TimerViewControllerRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIHostingController<ContentView> {
        UIHostingController(rootView: ContentView())
    }
    
    func updateUIViewController(_ uiViewController: UIHostingController<ContentView>, context: Context) {
    }
}
