// Kevin Li - 8:37 PM - 2/23/20

import SwiftUI

struct TagRow: View {
    let tag: Tag
    let isSelected: Bool

    private var tagColor: Color {
        Color(tag.uiColor)
    }

    var body: some View {
        HStack {
            HStack(spacing: 12) {
                tagDetailsStack
                checkAnimationIfSelected
            }
            Spacer()

            numberOfFavoritedVisitsView
        }
        .padding(12)
        .background(tagColor)
        .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
    }
}

private extension TagRow {
    private var tagDetailsStack: some View {
        VStack(alignment: .leading) {
            tagNameText
            numberOfLocationsText
            numberOfVisitsText
        }
        .animation(nil)
    }

    private var tagNameText: some View {
        Text(tag.name)
            .font(.headline)
            .foregroundColor(.white)
    }

    private var numberOfLocationsText: some View {
        Text("\(numberOfLocations) locations")
            .font(.caption)
            .foregroundColor(.white)
    }

    private var numberOfLocations: Int {
        tag.locations.count
    }

    private var numberOfVisitsText: some View {
        Text("\(numberOfVisits) visits")
            .font(.caption)
            .foregroundColor(.white)
    }

    private var numberOfVisits: Int {
        tag.locations.reduce(0, { count, location in
            count + location.visits.count
        })
    }
}

private extension TagRow {
    private var checkAnimationIfSelected: some View {
        Group {
            if isSelected {
                LottieView(fileName: "check1")
                    .frame(width: 40, height: 40)
            }
        }
    }
}

private extension TagRow {
    private var numberOfFavoritedVisitsView: some View {
        ZStack {
            starImage
                .padding(8)
                .foregroundColor(.yellow)
                .overlay(
                    Circle()
                        .stroke(Color.white, lineWidth: 1)
                )

            numberOfFavoritedVisitsText
                .padding(6)
                .background(Color.black)
                .clipShape(Circle())
                .foregroundColor(.white)
                .offset(x: 12, y: -16)
        }
    }

    private var starImage: some View {
        Group {
            if numberOfFavoritedVisits == 0 {
                Image(systemName: "star")
                    .resizable()
                    .frame(width: 20, height: 20)
            } else {
                Image(systemName: "star.fill")
                    .resizable()
                    .frame(width: 20, height: 20)
            }
        }
    }

    private var numberOfFavoritedVisitsText: some View {
        Text("\(numberOfFavoritedVisits)")
            .font(.system(size: 9))
            .foregroundColor(.white)
    }

    private var numberOfFavoritedVisits: Int {
        tag.locations.reduce(0, { favoritedVisits, location in
            favoritedVisits + location.visits.reduce(0, { favorited, visit in
                favorited + (visit.isFavorite ? 1 : 0)
            })
        })
    }
}

struct TagRow_Previews: PreviewProvider {
    static var previews: some View {
        TagRow(tag: .preview, isSelected: true).environment(\.managedObjectContext, CoreData.stack.context)
    }
}
