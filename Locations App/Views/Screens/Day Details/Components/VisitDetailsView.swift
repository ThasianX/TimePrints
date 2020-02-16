import SwiftUI

struct VisitDetailsView: View {
    @State private var mapFull = false
    @State private var isFavorite = false
    @State private var addNotesShowing = false
    @Binding var selectedIndex: Int

    let index: Int
    let visit: Visit
    let setActiveVisitLocationAndDisplayMap: (Visit) -> Void
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                header
                visitDetails
                interactableMapViewIfSelected
                notesIfSelected
                Spacer()
            }
            .padding(.top, isSelected ? 80 : 12)
            .padding(.leading, isSelected ? 0 : 40)
            .padding(.trailing, isSelected ? 0 : 40)
            .frame(height: VisitCellConstants.height(if: isSelected))
            .frame(maxWidth: VisitCellConstants.maxWidth(if: isSelected))
            .background(Color(UIColor.salmon))
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            .onTapGesture(perform: setSelectedVisitIndex)
        }
        .frame(height: VisitCellConstants.height(if: isSelected))
        .animation(.spring())
        .onAppear(perform: setFavoriteState)
    }
}

private extension VisitDetailsView {
    var header: some View {
        HStack {
            backButton
                .fade(!isSelected)
            Spacer()
            HStack {
                locationNameText
                starImageIfNotSelectedAndIsFavorite
            }
            Spacer()
            favoriteButton
                .fade(!isSelected)
        }
        .padding(.bottom, isSelected ? 20 : 0)
        .padding(.leading, isSelected ? 30 : 0)
        .padding(.trailing, isSelected ? 30 : 0)
    }

    private var backButton: some View {
        ZStack {
            Color(.white)
                .fade(!mapFull)
            BImage(perform: mapFull ? minimizeMap : unselectRow, image: .init(systemName: "arrow.left"))
        }
        .frame(width: 30, height: 30)
        .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
    }

    private var locationNameText: some View {
        Text(visit.location.name)
            .font(isSelected.when(true: .system(size: 22), false: .headline))
            .fontWeight(isSelected.when(true: .bold, false: .regular))
            .lineLimit(isSelected.when(true: nil, false: 1))
            .multilineTextAlignment(.center)
            .animation(nil)
    }

    private var starImageIfNotSelectedAndIsFavorite: some View {
        Group {
            if !isSelected && isFavorite {
                Image("star.fill")
                    .foregroundColor(.yellow)
            }
        }
    }

    private var favoriteButton: some View {
        BImage(perform: favorite, image: favoriteImage)
            .foregroundColor(.yellow)
    }

    private var favoriteImage: Image {
        if isFavorite {
            return Image("star.fill")
        } else {
            return Image("star")
        }
    }
}

private extension VisitDetailsView {
    private var visitDetails: some View {
        Group {
            if !mapFull {
                visitDurationText
                fullMonthWithDayOfWeekTextIfSelected
                    .padding(.bottom, isSelected ? 10 : 0)
                locationTagView
                    .padding(.bottom, isSelected ? 20 : 0)
            }
        }
        .scaleEffect(mapFull ? 0 : 1)
        .fade(mapFull)
    }

    private var visitDurationText: some View {
        Text(visit.visitDuration)
            .font(isSelected ? .system(size: 18) : .system(size: 10))
            .tracking(isSelected ? 2 : 0)
            .animation(nil)
    }

    private var fullMonthWithDayOfWeekTextIfSelected: some View {
        Group {
            if isSelected {
                fullMonthWithDayOfWeekText
            }
        }
    }

    private var fullMonthWithDayOfWeekText: some View {
        Text(visit.arrivalDate.fullMonthWithDayOfWeek.uppercased()).font(.caption)
    }

    private var locationTagView: some View {
        TagView(tag: visit.location.tag, displayName: isSelected)
            .padding(.init(top: 6, leading: 0, bottom: 4, trailing: 0))
    }
}

private extension VisitDetailsView {
    private var interactableMapViewIfSelected: some View {
        Group {
            if isSelected {
                staticMapView
                    .padding(.bottom, 10)
                Group {
                    locationAddressText
                    mapOptionButtons
                        .fade(!mapFull)
                        .scaleEffect(mapFull ? 1 : 0)
                }
                .padding(.leading, 80)
                .padding(.trailing, 80)
            }
        }
    }

    private var staticMapView: some View {
        StaticMapView(coordinate: visit.location.coordinate, name: visit.location.name, color: .blue)
            .frame(width: mapFull ? screen.width : screen.width / 2.5, height: mapFull ? screen.height * 8 / 15 : screen.width / 2.5)
            .cornerRadius(mapFull ? 0 : screen.width / 5)
            .onTapGesture(perform: toggleMapState)
            .animation(.spring())
    }

    private var locationAddressText: some View {
        Text(visit.location.address.uppercased())
            .font(.headline)
            .lineLimit(nil)
            .multilineTextAlignment(.center)
    }

    private var mapOptionButtons: some View {
        HStack(spacing: 20) {
            focusLocationOnAnnotatedMapButton
            openAppleMapsButton
        }
    }

    private var openAppleMapsButton: some View {
        Button(action: openAppleMaps) {
            Image(systemName: "arrow.up.right.diamond")
                .resizable()
                .frame(width: 35, height: 35)
        }
        .buttonStyle(PlainButtonStyle())
    }

    private var focusLocationOnAnnotatedMapButton: some View {
        Button(action: focusLocationOnAnnotatedMap) {
            Image(systemName: "magnifyingglass")
                .resizable()
                .frame(width: 35, height: 35)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

private extension VisitDetailsView {
    private var notesIfSelected: some View {
        Group {
            if isSelected {
                notesButton
                    .fade(mapFull)
                    .scaleEffect(mapFull ? 0 : 1)
            }
        }
    }

    private var notesButton: some View {
        Button(action: displayAddNotesView) {
            VStack(spacing: 2) {
                dividerView
                    .padding(.bottom, 20)

                notesHeaderText

                visitNotesTextWithDefaultIfEmpty

                dividerView
                    .padding(.top, 20)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }

    private var dividerView: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(Color.black)
            .frame(width: 60, height: 3)
    }

    private var notesHeaderText: some View {
        Text("NOTES")
            .font(.system(size: 22))
            .fontWeight(.bold)
            .tracking(2)
    }

    private var visitNotesTextWithDefaultIfEmpty: some View {
        Group {
            if visit.notes.isEmpty {
                emptyNotesText
            } else {
                visitNotesText
            }
        }
    }

    private var emptyNotesText: some View {
        Text("TAP TO ADD")
            .font(.caption)
    }

    private var visitNotesText: some View {
        Text(visit.notes)
            .font(.caption)
    }
}

private extension VisitDetailsView {
    private func setFavoriteState() {
        isFavorite = visit.isFavorite
    }

    private func setSelectedVisitIndex() {
        withAnimation {
            self.selectedIndex = index
        }
    }

    private var isSelected: Bool {
        selectedIndex == index
    }

    private func minimizeMap() {
        withAnimation {
            self.mapFull = false
        }
    }
    
    private func unselectRow() {
        withAnimation {
            self.selectedIndex = -1
        }
    }
    
    private func favorite() {
        withAnimation {
            isFavorite = visit.favorite()
        }
    }

    private func toggleMapState() {
        withAnimation {
            mapFull.toggle()
        }
    }

    private func openAppleMaps() {

    }

    private func focusLocationOnAnnotatedMap() {
        setActiveVisitLocationAndDisplayMap(visit)
    }

    private func displayAddNotesView() {
        addNotesShowing = true
    }
}

struct VisitDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            VisitDetailsView(selectedIndex: .constant(1), index: -1, visit: .preview, setActiveVisitLocationAndDisplayMap: { _ in }).previewLayout(.sizeThatFits)
            
            VisitDetailsView(selectedIndex: .constant(1), index: 1,  visit: .preview, setActiveVisitLocationAndDisplayMap: { _ in })
        }
        
    }
}
