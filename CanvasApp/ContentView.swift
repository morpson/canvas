import SwiftUI

struct ContentView: View {
    @StateObject private var wallpaperGenerator = WallpaperGenerator()
    @State private var selectedType: WallpaperType = .solid
    @State private var showingPreview = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            headerView
            
            // Main Content
            HStack(spacing: 0) {
                // Sidebar
                sidebarView
                
                // Main Panel
                mainPanelView
            }
        }
        .frame(minWidth: 800, minHeight: 600)
        .background(Color(NSColor.windowBackgroundColor))
        .sheet(isPresented: $showingPreview) {
            WallpaperPreviewView(wallpaperGenerator: wallpaperGenerator)
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "paintbrush.pointed.fill")
                    .font(.title2)
                    .foregroundColor(.blue)
                
                Text("Canvas")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Button("Preview") {
                    showingPreview = true
                }
                .buttonStyle(.borderedProminent)
                .disabled(wallpaperGenerator.currentWallpaper == nil)
            }
            
            Text("Create beautiful gradient wallpapers")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(24)
        .background(Color(NSColor.controlBackgroundColor))
    }
    
    private var sidebarView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Wallpaper Type")
                .font(.headline)
                .foregroundColor(.primary)
            
            ForEach(WallpaperType.allCases, id: \.self) { type in
                Button(action: {
                    selectedType = type
                    wallpaperGenerator.selectedType = type
                }) {
                    HStack {
                        Image(systemName: type.icon)
                            .foregroundColor(selectedType == type ? .white : .blue)
                        Text(type.displayName)
                            .foregroundColor(selectedType == type ? .white : .primary)
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(selectedType == type ? Color.blue : Color.clear)
                    )
                }
                .buttonStyle(.plain)
            }
            
            Spacer()
            
            // Generate Button
            Button("Generate Wallpaper") {
                wallpaperGenerator.generateWallpaper()
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .disabled(wallpaperGenerator.isGenerating)
        }
        .padding(20)
        .frame(width: 250)
        .background(Color(NSColor.controlBackgroundColor))
    }
    
    private var mainPanelView: some View {
        VStack(spacing: 20) {
            // Color Configuration
            colorConfigurationView
            
            // Additional Options
            additionalOptionsView
            
            Spacer()
        }
        .padding(24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var colorConfigurationView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Colors")
                .font(.headline)
                .foregroundColor(.primary)
            
            ColorPickerView(
                wallpaperType: selectedType,
                colors: $wallpaperGenerator.colors,
                angle: $wallpaperGenerator.angle,
                blur: $wallpaperGenerator.blur,
                twist: $wallpaperGenerator.twist
            )
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(NSColor.controlBackgroundColor))
        )
    }
    
    private var additionalOptionsView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Options")
                .font(.headline)
                .foregroundColor(.primary)
            
            HStack {
                Text("Size:")
                Picker("Size", selection: $wallpaperGenerator.size) {
                    Text("1366x768").tag("1366x768")
                    Text("1920x1080").tag("1920x1080")
                    Text("2560x1440").tag("2560x1440")
                    Text("3840x2160").tag("3840x2160")
                }
                .pickerStyle(.menu)
            }
            
            Toggle("Set as Desktop Wallpaper", isOn: $wallpaperGenerator.setAsWallpaper)
                .toggleStyle(.switch)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(NSColor.controlBackgroundColor))
        )
    }
}

#Preview {
    ContentView()
}
