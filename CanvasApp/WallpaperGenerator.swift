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
        case .twisted: return "spiral"
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
        // Get the path to the canvas script
        let bundlePath = Bundle.main.bundlePath
        let scriptPath = bundlePath.replacingOccurrences(of: "Canvas.app", with: "canvas")
        self.scriptPath = scriptPath
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
        
        // Build the command arguments
        var arguments: [String] = []
        
        // Add size
        arguments.append("-S")
        arguments.append(size)
        
        // Add wallpaper type
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
        
        // Add auto-set wallpaper flag
        if setAsWallpaper {
            arguments.append("-a")
        }
        
        // Add no preview flag
        arguments.append("-n")
        
        process.arguments = [scriptPath] + arguments
        
        // Set up input for colors and parameters
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
        // Look for the generated wallpaper in the Pictures/Canvas directory
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
    
    private func setAsDesktopWallpaper() {
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
