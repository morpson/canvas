import SwiftUI

struct ColorPickerView: View {
    let wallpaperType: WallpaperType
    @Binding var colors: [Color]
    @Binding var angle: Double
    @Binding var blur: Double
    @Binding var twist: Double
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            switch wallpaperType {
            case .solid:
                solidColorPicker
            case .linear, .radial, .twisted:
                gradientColorPicker
            case .bilinear:
                bilinearColorPicker
            case .plasma:
                plasmaColorPicker
            case .blurred:
                blurredOptions
            case .random:
                randomOptions
            }
        }
    }
    
    private var solidColorPicker: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Color")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            HStack {
                ColorPicker("", selection: Binding(
                    get: { colors.first ?? .blue },
                    set: { colors = [$0] }
                ))
                .frame(width: 50, height: 30)
                
                Text(colors.first?.description ?? "Blue")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
    
    private var gradientColorPicker: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Gradient Colors")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            HStack(spacing: 16) {
                VStack {
                    ColorPicker("", selection: Binding(
                        get: { colors.first ?? .blue },
                        set: { colors[0] = $0; if colors.count < 2 { colors.append(.purple) } }
                    ))
                    .frame(width: 50, height: 30)
                    
                    Text("Color 1")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                VStack {
                    ColorPicker("", selection: Binding(
                        get: { colors.count > 1 ? colors[1] : .purple },
                        set: { 
                            if colors.count > 1 {
                                colors[1] = $0
                            } else {
                                colors.append($0)
                            }
                        }
                    ))
                    .frame(width: 50, height: 30)
                    
                    Text("Color 2")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            if wallpaperType == .linear {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Angle: \(Int(angle))°")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Slider(value: $angle, in: 0...360, step: 1)
                        .accentColor(.blue)
                }
            }
            
            if wallpaperType == .twisted {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Twist Amount: \(Int(twist))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Slider(value: $twist, in: 0...500, step: 1)
                        .accentColor(.blue)
                }
            }
        }
    }
    
    private var bilinearColorPicker: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Four Corner Colors")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                ForEach(0..<4, id: \.self) { index in
                    VStack {
                        ColorPicker("", selection: Binding(
                            get: { 
                                if colors.count > index {
                                    return colors[index]
                                } else {
                                    let defaultColors: [Color] = [.red, .green, .yellow, .blue]
                                    return defaultColors[index]
                                }
                            },
                            set: { 
                                while colors.count <= index {
                                    let defaultColors: [Color] = [.red, .green, .yellow, .blue]
                                    colors.append(defaultColors[colors.count])
                                }
                                colors[index] = $0
                            }
                        ))
                        .frame(width: 50, height: 30)
                        
                        Text("Color \(index + 1)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
    }
    
    private var plasmaColorPicker: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Plasma Options")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Text("Plasma generates random colorful patterns")
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.bottom, 8)
        }
    }
    
    private var blurredOptions: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Blur Options")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Blur Strength: \(Int(blur))")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Slider(value: $blur, in: 1...30, step: 1)
                    .accentColor(.blue)
            }
        }
    }
    
    private var randomOptions: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Random Generation")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Text("Generates a random wallpaper with random colors and effects")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    ColorPickerView(
        wallpaperType: .linear,
        colors: .constant([.blue, .purple]),
        angle: .constant(45),
        blur: .constant(14),
        twist: .constant(150)
    )
    .padding()
}
