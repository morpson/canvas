import SwiftUI

struct WallpaperPreviewView: View {
    @ObservedObject var wallpaperGenerator: WallpaperGenerator
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 20) {
            // Header
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
            
            // Preview Image
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
            
            // Actions
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

#Preview {
    WallpaperPreviewView(wallpaperGenerator: WallpaperGenerator())
}
