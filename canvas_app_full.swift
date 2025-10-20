import SwiftUI
import AppKit

enum WallpaperType: String, CaseIterable {
    case solid = "solid"
    case linear = "linear"
    case radial = "radial"
    case twisted = "twisted"
    case bilinear = "bilinear"
    case plasma = "plasma"
    case blurred = "blurred"
    case random = "random"
    
    var displayName: String {
        switch self {
        case .solid: return "Solid Color"
        case .linear: return "Linear Gradient"
        case .radial: return "Radial Gradient"
        case .twisted: return "Twisted Gradient"
        case .bilinear: return "Bilinear Gradient"
        case .plasma: return "Plasma"
        case .blurred: return "Blurred Noise"
        case .random: return "Random"
        }
    }
    
    var icon: String {
        switch self {
        case .solid: return "square.fill"
        case .linear: return "rectangle.fill"
        case .radial: return "circle.fill"
        case .twisted: return "line.3.crossed.swirl.circle"
        case .bilinear: return "square.grid.4x3.fill"
        case .plasma: return "waveform"
        case .blurred: return "cloud.fill"
        case .random: return "shuffle"
        }
    }
}

class WallpaperGenerator: ObservableObject {
    @Published var selectedType: WallpaperType = .solid
    @Published var colors: [Color] = [.blue, .purple]
    @Published var angle: Double = 0
    @Published var blur: Double = 14
    @Published var twist: Double = 150
    @Published var size: String = "1366x768"
    @Published var setAsWallpaper: Bool = true
    @Published var isGenerating: Bool = false
    @Published var currentWallpaper: NSImage?
    
    private let scriptPath: String
    
    init() {
        self.scriptPath = "./canvas-simple"
    }
    
    func generateWallpaper() {
        isGenerating = true
        
        DispatchQueue.global(qos: .userInitiated).async {
            let success = self.runCanvasScript()
            
            DispatchQueue.main.async {
                self.isGenerating = false
                if success {
                    self.loadGeneratedWallpaper()
                    if self.setAsWallpaper {
                        self.setAsDesktopWallpaper()
                    }
                }
            }
        }
    }
    
    private func runCanvasScript() -> Bool {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/bin/bash")
        
        var arguments: [String] = []
        arguments.append("-S")
        arguments.append(size)
        
        switch selectedType {
        case .solid:
            arguments.append("-s")
        case .linear:
            arguments.append("-l")
        case .radial:
            arguments.append("-r")
        case .twisted:
            arguments.append("-t")
        case .bilinear:
            arguments.append("-b")
        case .plasma:
            arguments.append("-p")
        case .blurred:
            arguments.append("-B")
        case .random:
            arguments.append("-R")
        }
        
        if setAsWallpaper {
            arguments.append("-a")
        }
        arguments.append("-n")
        
        process.arguments = [scriptPath] + arguments
        
        var input = ""
        
        switch selectedType {
        case .solid:
            if let color = colors.first {
                let nsColor = NSColor(color)
                input = nsColor.hexString + "\n"
            }
        case .linear:
            if colors.count >= 2 {
                let color1 = NSColor(colors[0]).hexString
                let color2 = NSColor(colors[1]).hexString
                input = "\(color1)\n\(color2)\n\(Int(angle))\n"
            }
        case .radial:
            if colors.count >= 2 {
                let color1 = NSColor(colors[0]).hexString
                let color2 = NSColor(colors[1]).hexString
                input = "\(color1)\n\(color2)\n"
            }
        case .twisted:
            if colors.count >= 2 {
                let color1 = NSColor(colors[0]).hexString
                let color2 = NSColor(colors[1]).hexString
                input = "\(color1)\n\(color2)\n\(Int(twist))\n"
            }
        case .bilinear:
            if colors.count >= 4 {
                let color1 = NSColor(colors[0]).hexString
                let color2 = NSColor(colors[1]).hexString
                let color3 = NSColor(colors[2]).hexString
                let color4 = NSColor(colors[3]).hexString
                input = "\(color1)\n\(color2)\n\(color3)\n\(color4)\n"
            }
        case .plasma:
            input = ""
        case .blurred:
            input = "\(Int(blur))\n"
        case .random:
            input = ""
        }
        
        let inputData = input.data(using: .utf8)!
        let inputPipe = Pipe()
        process.standardInput = inputPipe
        
        do {
            try process.run()
            if !input.isEmpty {
                inputPipe.fileHandleForWriting.write(inputData)
            }
            inputPipe.fileHandleForWriting.closeFile()
            process.waitUntilExit()
            return process.terminationStatus == 0
        } catch {
            print("Error running canvas script: \(error)")
            return false
        }
    }
    
    private func loadGeneratedWallpaper() {
        let picturesPath = FileManager.default.urls(for: .picturesDirectory, in: .userDomainMask).first!
        let canvasPath = picturesPath.appendingPathComponent("Canvas")
        
        do {
            let files = try FileManager.default.contentsOfDirectory(at: canvasPath, includingPropertiesForKeys: [.creationDateKey])
            let sortedFiles = files.sorted { file1, file2 in
                let date1 = try? file1.resourceValues(forKeys: [.creationDateKey]).creationDate ?? Date.distantPast
                let date2 = try? file2.resourceValues(forKeys: [.creationDateKey]).creationDate ?? Date.distantPast
                return date1 ?? Date.distantPast > date2 ?? Date.distantPast
            }
            
            if let latestFile = sortedFiles.first {
                currentWallpaper = NSImage(contentsOf: latestFile)
            }
        } catch {
            print("Error loading wallpaper: \(error)")
        }
    }
    
    func setAsDesktopWallpaper() {
        guard let wallpaper = currentWallpaper else { return }
        
        let picturesPath = FileManager.default.urls(for: .picturesDirectory, in: .userDomainMask).first!
        let canvasPath = picturesPath.appendingPathComponent("Canvas")
        
        do {
            let files = try FileManager.default.contentsOfDirectory(at: canvasPath, includingPropertiesForKeys: [.creationDateKey])
            let sortedFiles = files.sorted { file1, file2 in
                let date1 = try? file1.resourceValues(forKeys: [.creationDateKey]).creationDate ?? Date.distantPast
                let date2 = try? file2.resourceValues(forKeys: [.creationDateKey]).creationDate ?? Date.distantPast
                return date1 ?? Date.distantPast > date2 ?? Date.distantPast
            }
            
            if let latestFile = sortedFiles.first {
                try NSWorkspace.shared.setDesktopImageURL(latestFile, for: NSScreen.main!, options: [:])
            }
        } catch {
            print("Error setting wallpaper: \(error)")
        }
    }
}

extension NSColor {
    var hexString: String {
        let red = Int(round(self.redComponent * 0xFF))
        let green = Int(round(self.greenComponent * 0xFF))
        let blue = Int(round(self.blueComponent * 0xFF))
        return String(format: "#%02X%02X%02X", red, green, blue)
    }
}

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

struct WallpaperPreviewView: View {
    @ObservedObject var wallpaperGenerator: WallpaperGenerator
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Wallpaper Preview")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Button("Close") {
                    dismiss()
                }
                .buttonStyle(.bordered)
            }
            
            if let wallpaper = wallpaperGenerator.currentWallpaper {
                Image(nsImage: wallpaper)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 400, maxHeight: 300)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)
            } else {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.1))
                    .frame(width: 400, height: 300)
                    .overlay(
                        VStack {
                            Image(systemName: "photo")
                                .font(.system(size: 48))
                                .foregroundColor(.gray)
                            Text("No wallpaper generated")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    )
            }
            
            HStack(spacing: 16) {
                Button("Set as Wallpaper") {
                    wallpaperGenerator.setAsDesktopWallpaper()
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
                .disabled(wallpaperGenerator.currentWallpaper == nil)
                
                Button("Generate New") {
                    wallpaperGenerator.generateWallpaper()
                }
                .buttonStyle(.bordered)
                .disabled(wallpaperGenerator.isGenerating)
                
                if wallpaperGenerator.isGenerating {
                    ProgressView()
                        .scaleEffect(0.8)
                }
            }
        }
        .padding(24)
        .frame(width: 500, height: 450)
    }
}

struct ContentView: View {
    @StateObject private var wallpaperGenerator = WallpaperGenerator()
    @State private var selectedType: WallpaperType = .solid
    @State private var showingPreview = false
    
    var body: some View {
        VStack(spacing: 0) {
            headerView
            
            HStack(spacing: 0) {
                sidebarView
                mainPanelView
            }
        }
        .frame(minWidth: 900, minHeight: 650)
        .background(Color(NSColor.windowBackgroundColor))
        .sheet(isPresented: $showingPreview) {
            WallpaperPreviewView(wallpaperGenerator: wallpaperGenerator)
        }
    }
    
    private var headerView: some View {
        HStack {
            HStack(spacing: 12) {
                Image(systemName: "paintbrush.pointed.fill")
                    .font(.title2)
                    .foregroundColor(.blue)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Canvas")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text("Create beautiful gradient wallpapers")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            Button("Preview") {
                showingPreview = true
            }
            .buttonStyle(.borderedProminent)
            .disabled(wallpaperGenerator.currentWallpaper == nil)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(Color(NSColor.controlBackgroundColor))
        .shadow(color: Color.primary.opacity(0.1), radius: 8, x: 0, y: 4)
    }
    
    private var sidebarView: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            VStack(alignment: .leading) {
                Text("Wallpaper Type")
                    .font(.headline)
                    .foregroundColor(.primary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .padding(.bottom, 12)
            
            // Scrollable content
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 8) {
                    ForEach(WallpaperType.allCases, id: \.self) { type in
                        Button(action: {
                            selectedType = type
                            wallpaperGenerator.selectedType = type
                        }) {
                            HStack(spacing: 12) {
                                Image(systemName: type.icon)
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(selectedType == type ? .white : .blue)
                                    .frame(width: 20, alignment: .leading)
                                
                                Text(type.displayName)
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(selectedType == type ? .white : .primary)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 10)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(selectedType == type ? Color.blue : Color.clear)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.primary.opacity(0.1), lineWidth: 1)
                            )
                            .shadow(color: Color.primary.opacity(selectedType == type ? 0.2 : 0.08), radius: selectedType == type ? 6 : 3, x: 0, y: selectedType == type ? 3 : 1)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)
            }
            
            Spacer()
            
            // Generate button
            VStack(alignment: .leading) {
                Button("Generate Wallpaper") {
                    wallpaperGenerator.generateWallpaper()
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .disabled(wallpaperGenerator.isGenerating)
                .frame(maxWidth: .infinity)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
        .frame(width: 280)
        .background(.ultraThinMaterial, in: Rectangle())
        .shadow(color: Color.primary.opacity(0.08), radius: 8, x: 0, y: 3)
    }
    
    private var mainPanelView: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                colorConfigurationView
                additionalOptionsView
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
    
    private var colorConfigurationView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Colors")
                .font(.headline)
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            ColorPickerView(
                wallpaperType: selectedType,
                colors: $wallpaperGenerator.colors,
                angle: $wallpaperGenerator.angle,
                blur: $wallpaperGenerator.blur,
                twist: $wallpaperGenerator.twist
            )
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(NSColor.controlBackgroundColor))
        )
        .shadow(color: Color.primary.opacity(0.08), radius: 6, x: 0, y: 2)
    }
    
    private var additionalOptionsView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Options")
                .font(.headline)
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("Size:")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Spacer()
                    Picker("Size", selection: $wallpaperGenerator.size) {
                        Text("1366x768").tag("1366x768")
                        Text("1920x1080").tag("1920x1080")
                        Text("2560x1440").tag("2560x1440")
                        Text("3840x2160").tag("3840x2160")
                    }
                    .pickerStyle(.menu)
                    .frame(width: 120)
                }
                
                HStack {
                    Text("Set as Desktop Wallpaper")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Spacer()
                    Toggle("", isOn: $wallpaperGenerator.setAsWallpaper)
                        .toggleStyle(.switch)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(NSColor.controlBackgroundColor))
        )
        .shadow(color: Color.primary.opacity(0.08), radius: 6, x: 0, y: 2)
    }
}

@main
struct CanvasApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentSize)
    }
}
