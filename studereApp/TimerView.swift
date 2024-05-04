import SwiftUI

struct TimerView: View {
    var body: some View {
        NavigationView {
            TimerScreen()
        }
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView()
    }
}

struct TimerScreen: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var isTimerRunning = false
    @State private var timerProgress: CGFloat = 0
    @State private var elapsedSeconds = 0
    @State private var selectedHours = 0
    @State private var selectedMinutes = 0
    @State private var selectedSeconds = 0
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    //Picker options
    private let hours = Array(0...23)
    private let minutes = Array(0...59)
    private let seconds = Array(0...59)
    
    //Total time in seconds
    private var totalDuration: Int {
        selectedHours * 3600 + selectedMinutes * 60 + selectedSeconds
    }
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.06).edgesIgnoringSafeArea(.all)
            
            VStack {
                //Back button
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
                
                //Timer progress circle
                ZStack {
                    Circle()
                        .trim(from: 0, to: 1)
                        .stroke(Color.black.opacity(0.09), style: StrokeStyle(lineWidth: 40, lineCap: .round))
                        .frame(width: 320, height: 320)
                    
                    Circle()
                        .trim(from: 0, to: timerProgress)
                        .stroke(Color.purple, style: StrokeStyle(lineWidth: 40, lineCap: .round))
                        .frame(width: 320, height: 320)
                        .rotationEffect(.init(degrees: -90))
                    
                    VStack {
                        Text(formatTime(seconds: elapsedSeconds))
                            .font(.system(size: 50))
                            .fontWeight(.bold)
                    }
                }
                
                //Duration picker
                HStack {
                    //Hours picker
                    VStack {
                        Spacer()
                        Text("Hours")
                            .font(.headline)
                        
                        Picker("Hours", selection: $selectedHours) {
                            ForEach(hours, id: \.self) { hour in
                                Text("\(hour)")
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .frame(width: 80, height: 100)
                        .clipped()
                    }
                    
                    //Minutes picker
                    VStack {
                        Spacer()
                        Text("Minutes")
                            .font(.headline)
                        
                        Picker("Minutes", selection: $selectedMinutes) {
                            ForEach(minutes, id: \.self) { minute in
                                Text("\(minute)")
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .frame(width: 80, height: 100)
                        .clipped()
                    }
                    
                    //Seconds picker
                    VStack {
                        Spacer()
                        Text("Seconds")
                            .font(.headline)
                        
                        Picker("Seconds", selection: $selectedSeconds) {
                            ForEach(seconds, id: \.self) { second in
                                Text("\(second)")
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .frame(width: 80, height: 100)
                        .clipped()
                    }
                }
                
                // Start, pause and restart buttons
                HStack(spacing: 20) {
                    Button(action: {
                        if elapsedSeconds == totalDuration {
                            resetTimer()
                        }
                        isTimerRunning.toggle()
                    }) {
                        HStack(spacing: 15) {
                            Image(systemName: isTimerRunning ? "pause.fill" : "play.fill")
                                .foregroundColor(.white)
                            
                            Text(isTimerRunning ? "Pause" : "Start")
                                .foregroundColor(.white)
                        }
                        .padding(.vertical)
                        .frame(width: (UIScreen.main.bounds.width / 2) - 55)
                        .background(Color.purple)
                        .clipShape(Capsule())
                        .shadow(radius: 6)
                    }
                    
                    Button(action: {
                        resetTimer()
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
        .onReceive(timer) { _ in
            if isTimerRunning {
                if elapsedSeconds < totalDuration {
                    elapsedSeconds += 1
                    timerProgress = CGFloat(elapsedSeconds) / CGFloat(totalDuration)
                } else {
                    isTimerRunning = false
                }
            }
        }
    }
    
    //Reset timer
    private func resetTimer() {
        elapsedSeconds = 0
        timerProgress = 0
    }
    
    //Time formatted
    private func formatTime(seconds: Int) -> String {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        let seconds = (seconds % 3600) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}

struct TimerViewControllerRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIHostingController<TimerView> {
        UIHostingController(rootView: TimerView())
    }
    
    func updateUIViewController(_ uiViewController: UIHostingController<TimerView>, context: Context) {
    }
}
