import SwiftUI

struct VisitPreviewCell: View {
    let visit: Visit
    
    var body: some View {
        HStack(alignment: .center) {
            TagView(tag: visit.location.tag)
                .rotated(.degrees(90))

            VStack(alignment: .leading) {
                locationName
                visitDurationAndAddress
            }
        
            Spacer()
            
            favoriteIcon
        }
        .frame(height: 50)
        .padding(.init(top: 0, leading: 10, bottom: 0, trailing: 10))
    }
}

// MARK: - Content
private extension VisitPreviewCell {
    private var locationName: some View {
        Text(visit.location.name)
            .font(.headline)
            .fontWeight(.bold)
            .lineLimit(1)
    }
    
    private var visitDurationAndAddress: some View {
        Text("\(visit.visitDuration)    \(visit.location.address)")
            .font(.caption)
            .lineLimit(1)
    }
    
    private var favoriteIcon: some View {
        Group {
            if visit.isFavorite {
                Image(systemName: "star.fill")
                    .imageScale(.medium)
                    .foregroundColor(.yellow)
            }
        }
    }
}

struct LocationPreviewCell_Previews: PreviewProvider {
    static var previews: some View {
        VisitPreviewCell(visit: .preview)
    }
}
