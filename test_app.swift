import SwiftUI

struct ContentView: View {
    @State private var selectedColor = Color.blue
    @State private var isGenerating = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Canvas Wallpaper Generator")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Create beautiful gradient wallpapers")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            ColorPicker("Choose a color", selection: $selectedColor)
                .frame(width: 200)
            
            Button("Generate Solid Color Wallpaper") {
                generateWallpaper()
            }
            .buttonStyle(.borderedProminent)
            .disabled(isGenerating)
            
            if isGenerating {
                ProgressView("Generating...")
            }
        }
        .padding(40)
        .frame(width: 400, height: 300)
    }
    
    private func generateWallpaper() {
        isGenerating = true
        
        DispatchQueue.global(qos: .userInitiated).async {
            let process = Process()
            process.executableURL = URL(fileURLWithPath: "/bin/bash")
            process.arguments = ["./canvas-simple", "-s", "-n"]
            
            let inputPipe = Pipe()
            process.standardInput = inputPipe
            
            do {
                try process.run()
                
                // Convert SwiftUI Color to hex
                let nsColor = NSColor(selectedColor)
                let hex = String(format: "#%02X%02X%02X", 
                               Int(nsColor.redComponent * 255),
                               Int(nsColor.greenComponent * 255),
                               Int(nsColor.blueComponent * 255))
                
                let input = hex + "\n"
                inputPipe.fileHandleForWriting.write(input.data(using: .utf8)!)
                inputPipe.fileHandleForWriting.closeFile()
                
                process.waitUntilExit()
                
                DispatchQueue.main.async {
                    self.isGenerating = false
                    if process.terminationStatus == 0 {
                        // Open the generated wallpaper
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
                                NSWorkspace.shared.open(latestFile)
                            }
                        } catch {
                            print("Error opening wallpaper: \(error)")
                        }
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.isGenerating = false
                    print("Error: \(error)")
                }
            }
        }
    }
}

@main
struct TestApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentSize)
    }
}
