import SwiftUI

struct VisitPreviewCell: View {
    let visit: Visit

    private var location: Location {
        visit.location
    }
    
    var body: some View {
        HStack(alignment: .center) {
            TagView(tag: location.tag)
                .rotated(.degrees(90))

            VStack(alignment: .leading) {
                locationName
                visitDurationAndAddress
            }
        
            Spacer()

            if visit.isFavorite {
                favoriteIcon
            }
        }
        .frame(height: 50)
        .padding(.init(top: 0, leading: 10, bottom: 0, trailing: 10))
    }
}

private extension VisitPreviewCell {
    private var locationName: some View {
        Text(location.name)
            .font(.headline)
            .fontWeight(.bold)
            .lineLimit(1)
    }
    
    private var visitDurationAndAddress: some View {
        Text("\(visit.duration)    \(location.address)")
            .font(.caption)
            .lineLimit(1)
    }
    
    private var favoriteIcon: some View {
        Image(systemName: "star.fill")
            .imageScale(.medium)
            .foregroundColor(.yellow)
    }
}

struct LocationPreviewCell_Previews: PreviewProvider {
    static var previews: some View {
        VisitPreviewCell(visit: .preview)
    }
}
