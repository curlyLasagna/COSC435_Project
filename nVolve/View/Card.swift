import SwiftUI

struct Card: View {
    var image: Image
    var title: String
    var time: String
    var room: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            image
                .resizable()
                .scaledToFit() // Ensures the image fills the available width
                .frame(height: 120) // Increase image height to fill more space
                .clipped() // Ensures the image doesn't overflow the frame
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.purple, lineWidth: 1)
                )
            
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.headline) 
                    .fontWeight(.semibold)
                    .lineLimit(1)
                
                Text("\(time) / \(room)") // Combined time and room into a single line
                    .font(.caption)
                    .bold()
                
                Text("Description")
                    .font(.caption)
                    .lineLimit(2)
            }
            .padding(8)
            .background(Color.yellow.opacity(0.8))
            .cornerRadius(8)
            .foregroundColor(.black)
        }
        .foregroundColor(.black)
        .frame(width: 180, height: 240) // Adjusted card size
        .background(Color.white)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.yellow, lineWidth: 1)
        )
        .shadow(color: Color.gray.opacity(0.2), radius: 2, x: 0, y: 1)
    }
}

struct Card_Previews: PreviewProvider {
    static var previews: some View {
        Card(
            image: Image(systemName: "photo"),
            title: "Event Title",
            time: "10:00 AM",
            room: "Room 204"
        )
        .previewLayout(.sizeThatFits)
        .padding()
    }
}

