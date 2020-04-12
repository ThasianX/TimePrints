import SwiftUI

struct FavoriteButton: View {
    @State private var isFavorite: Bool
    private let visit: Visit

    var favorited: Bool {
        isFavorite
    }

    init(visit: Visit) {
        self._isFavorite = State(initialValue: visit.isFavorite)
        self.visit = visit
    }

    var body: some View {
        BImage(perform: favorite, image: favoriteImage)
            .foregroundColor(.yellow)
    }

    private func favorite() {
        isFavorite = visit.favorite()
    }

    private var favoriteImage: Image {
        isFavorite ? Image("star.fill") : Image("star")
    }
}

struct FavoriteButton_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteButton(visit: .preview)
    }
}
