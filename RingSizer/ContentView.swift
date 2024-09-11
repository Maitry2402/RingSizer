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
    @State private var ringSize: CGFloat = 100
    @State private var showRingSize: Bool = false

    var body: some View {
        VStack(spacing: 20) {
            TopBarView()

            Spacer()

            Text("Put the ring on the circle")
                .font(.custom("Times New Roman", size: 18))
                .fontWeight(.bold)
                .padding(.bottom, 10)

            ZStack {
                // Custom grid with bold 3x3 and smaller grids inside
                AccurateGridShape(bold: false, borderColor: .clear)
                    .stroke(lineWidth: 0.05) // For sub-grid
                    .overlay(
                        AccurateGridShape(bold: true, borderColor: .gray)
                            .stroke(Color.gray, lineWidth: 0.8) // Change color for bold lines
                    )
                    .frame(width: 250, height: 250)
                    .background(.thinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 15))

                Circle()
                    .fill(Color.orange)
                    .frame(width: ringSize, height: ringSize)

                HStack {
                    Image(systemName: "arrow.left")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 10, height: 10)
                        .foregroundColor(.black)

                    Spacer()

                    Image(systemName: "arrow.right")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 10, height: 10)
                        .foregroundColor(.black)
                }
                .frame(width: ringSize + 5)
            }

            Button(action: {
                showRingSize = true
            }) {
                Text("Get the ring size         ")
                    .font(.custom("Times New Roman", size: 18))
                    .fontWeight(.semibold)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.black)
                    .cornerRadius(10)
            }

            // Show the ring size in mm
            if showRingSize {
                Text("Ring Size: \(String(format: "%.2f", ringSize)) mm")
                    .font(.title2)
            }

            CustomSlider(ringSize: $ringSize)

            BottomBarView()
        }
    }
}
struct CustomSlider: View {
    @Binding var ringSize: CGFloat

    var body: some View {
        VStack {
            Text("Use the slider to choose the size")
                .font(.custom("Times New Roman", size: 18))
                .fontWeight(.bold)
                .padding(.bottom, 20)

            ZStack(alignment: .bottom) {  // Align everything at the bottom
                HStack(spacing: 2.5) {
                    Spacer()

                    ForEach(0..<20) { tick in
                        Rectangle()
                            .fill(tick % 2 == 0 ? Color.gray : Color.gray)
                            .frame(width: 1, height: tick % 2 == 0 ? 20 : 10) // Big for even, small for odd
                        Spacer()
                    }

                    Spacer()
                }
                .frame(height: 20)

                // Indicator - Orange Line1
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color.orange)
                    .frame(width: 4, height: 35)
                    .offset(x: valueToPosition(value: ringSize), y: 0)
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                let newValue = positionToValue(position: gesture.location.x)
                                if newValue >= 30 && newValue <= 150 {
                                    ringSize = newValue
                                }
                            }
                    )
            }
            .frame(height: 40)
            .padding(.horizontal, 30)

            HStack {
                Button(action: {
                    ringSize = max(20, ringSize - 0.5)
                }) {
                    Text("-")
                        .font(.title)
                        .foregroundColor(.black)
                        .frame(width: 50, height: 50)
                        .background(RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.black, lineWidth: 0.5))
                }

                Text("Fine-tune")
                    .font(.custom("Times New Roman", size: 18))
                    .padding(.horizontal, 20)

                Button(action: {
                    ringSize = min(200, ringSize + 0.5)
                }) {
                    Text("+")
                        .font(.title)
                        .foregroundColor(.black)
                        .frame(width: 50, height: 50)
                        .background(RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.black, lineWidth: 0.5))
                }
            }
            .padding(.top, 20)
        }
    }

    // Convert value to position
    func valueToPosition(value: CGFloat) -> CGFloat {
        let totalWidth: CGFloat = 250
        return (value - 20) * (totalWidth / 180) - totalWidth / 2
    }

    // Convert position to value
    func positionToValue(position: CGFloat) -> CGFloat {
        let totalWidth: CGFloat = 250
        return (position + totalWidth / 2) / (totalWidth / 180) + 20
    }
}

struct BottomBarView: View {
    var body: some View {
        HStack {
            Spacer()
            Button(action: {
                // Gear action
            }){
                VStack {
                    Image(systemName: "checkmark.circle")
                        .foregroundColor(.black)
                    Text("Ring Sizer")
                        .font(.caption)
                        .foregroundColor(.black)
                }
            }
            Spacer()
            Button(action: {
                // Gear action
            }){
                VStack {
                    Image(systemName: "hand.tap")
                        .foregroundColor(.black)
                        .font(.system(size: 25))
                    Text("Finger Sizer")
                        .font(.caption)
                        .foregroundColor(.black)
                }
            }
            Spacer()
            Button(action: {
                // Gear action
            }){
                VStack {
                    Image(systemName: "arrow.right.arrow.left")
                        .foregroundColor(.black)
                    Text("Converter")
                        .font(.caption)
                        .foregroundColor(.black)

                }
            }
            Spacer()
        }
        .padding()
    }
}

struct AccurateGridShape: Shape {
    var bold: Bool = false  // Flag to decide whether to draw bold lines
    var borderColor: Color = .clear  // Color for the outer border

    func path(in rect: CGRect) -> Path {
        var path = Path()

        let numberOfLargeLines = 3
        let largeGridSize = rect.width / CGFloat(numberOfLargeLines)

        let numberOfSmallLines = 10  // Smaller sub-grid lines inside the large cells
        let smallGridSize = largeGridSize / CGFloat(numberOfSmallLines)

        for i in 0..<numberOfLargeLines {
            let position = largeGridSize * CGFloat(i + 1)

            // Step 1: Draw thicker lines for the 3x3 grid when 'bold' is true
            if bold {
                path.move(to: CGPoint(x: position, y: rect.minY))
                path.addLine(to: CGPoint(x: position, y: rect.maxY))

                path.move(to: CGPoint(x: rect.minX, y: position))
                path.addLine(to: CGPoint(x: rect.maxX, y: position))
            }
            else {
                // Step 2: Draw smaller, thinner sub-grid lines
                for j in 0..<numberOfSmallLines {
                    let smallPosition = smallGridSize * CGFloat(j + 1)

                    // Vertical sub-grid lines
                    path.move(to: CGPoint(x: largeGridSize * CGFloat(i) + smallPosition, y: 0))
                    path.addLine(to: CGPoint(x: largeGridSize * CGFloat(i) + smallPosition, y: rect.height))

                    // Horizontal sub-grid lines
                    path.move(to: CGPoint(x: 0, y: largeGridSize * CGFloat(i) + smallPosition))
                    path.addLine(to: CGPoint(x: rect.width, y: largeGridSize * CGFloat(i) + smallPosition))
                }
            }
        }

        // Draw the outer border with the specified color
        if bold {
            path.move(to: CGPoint(x: rect.minX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        }

        return path
    }
}
struct TopBarView: View {
    var body: some View {
        HStack {
            Button(action: {
                // Gear action
            }) {
                Image(systemName: "gearshape")
                    .foregroundColor(.black)
                    .frame(width: 40, height: 40)
                    .background(Circle().strokeBorder(Color.gray.opacity(0.5), lineWidth: 1))
            }

            Spacer()

            HStack(spacing: 16) {
                Button(action: {
                    // Reset action
                }) {
                    Image(systemName: "arrow.counterclockwise")
                        .foregroundColor(.black)
                        .frame(width: 40, height: 40)
                        .background(Circle().strokeBorder(Color.gray.opacity(0.5), lineWidth: 1))
                }

                Button(action: {
                    // Info action
                }) {
                    Image(systemName: "info.circle")
                        .foregroundColor(.black)
                        .frame(width: 40, height: 40)
                        .background(Circle().strokeBorder(Color.gray.opacity(0.5), lineWidth: 1))
                }
            }
        }
        .padding()
        .background(Color.white)
    }
}
