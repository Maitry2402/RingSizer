import SwiftUI

struct ContentView: View {
    var body: some View {
        RingSizerView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct RingSizerView: View {
    @State private var ringSize: CGFloat = 100 // Initial size of the circle
    @State private var showRingSize: Bool = false // Controls whether the ring size in mm is shown

    var body: some View {
        VStack(spacing: 20) {
            // Top Bar Icons
            HStack {
                Button(action: {
                    // Action for gear icon
                }) {
                    Image(systemName: "gearshape.fill")
                        .font(.title2)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                HStack(spacing: 20) {
                    Button(action: {
                        // Action for undo icon
                    }) {
                        Image(systemName: "arrow.uturn.backward.circle.fill")
                            .font(.title2)
                            .foregroundColor(.gray)
                    }
                    
                    Button(action: {
                        // Action for info icon
                    }) {
                        Image(systemName: "info.circle.fill")
                            .font(.title2)
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.top, 20)
            
            Spacer()
            
            // Instruction Text
            Text("Put the ring on the circle")
                .font(.headline)
                .padding(.bottom, 10)
            
            // Circle inside a grid
            ZStack {
                // Background grid
                GridShape()
                    .stroke(Color.gray, lineWidth: 0.5)
                    .frame(width: 200, height: 200)
                
                // Resizable circle
                Circle()
                    .fill(Color.orange)
                    .frame(width: ringSize, height: ringSize)
            }
            
            // "Get the ring size" button
            Button(action: {
                showRingSize = true
            }) {
                Text("Get the ring size")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
            }
            
            // Show the ring size in mm
            if showRingSize {
                Text("Ring Size: \(String(format: "%.2f", ringSize)) mm")
                    .font(.title2)
                    .padding(.top, 20)
            }
            
            // Slider for adjusting the ring size
            VStack {
                Text("Use the slider to choose the size")
                    .font(.headline)
                
                Slider(value: $ringSize, in: 20...200, step: 1)
                    .padding(.horizontal)
                
                HStack {
                    Button(action: {
                        ringSize = max(20, ringSize - 1)
                    }) {
                        Text("-")
                            .font(.title)
                            .padding()
                    }
                    
                    Text("Fine-tune")
                        .font(.subheadline)
                    
                    Button(action: {
                        ringSize = min(200, ringSize + 1)
                    }) {
                        Text("+")
                            .font(.title)
                            .padding()
                    }
                }
            }
            
            Spacer()
            
            // Bottom Tab Bar
            HStack {
                Spacer()
                
                VStack {
                    Image(systemName: "checkmark.circle")
                    Text("Ring Sizer")
                        .font(.caption)
                }
                Spacer()
                
                VStack {
                    Image(systemName: "hand.tap.fill")
                    Text("Finger Sizer")
                        .font(.caption)
                }
                Spacer()
                
                VStack {
                    Image(systemName: "arrow.right.arrow.left")
                    Text("Converter")
                        .font(.caption)
                }
                Spacer()
            }
            .padding()
            .background(Color.white.shadow(radius: 10))
            .frame(height: 80)
        }
        .padding(.bottom)
    }
}

struct GridShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let numberOfLines = 3
        
        for i in 0..<numberOfLines {
            let position = rect.width / CGFloat(numberOfLines) * CGFloat(i + 1)
            
            // Vertical lines
            path.move(to: CGPoint(x: position, y: rect.minY))
            path.addLine(to: CGPoint(x: position, y: rect.maxY))
            
            // Horizontal lines
            path.move(to: CGPoint(x: rect.minX, y: position))
            path.addLine(to: CGPoint(x: rect.maxX, y: position))
        }
        
        return path
    }
}
