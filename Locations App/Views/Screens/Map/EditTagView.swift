//
//  EditTagView.swift
//  Locations App
//
//  Created by Kevin Li on 2/3/20.
//  Copyright © 2020 Kevin Li. All rights reserved.
//

import SwiftUI

struct EditTagView: View {
    @FetchRequest(entity: Tag.entity(), sortDescriptors: []) var tags: FetchedResults<Tag>
    @State private var showAdd: Bool = false
    @State private var tagInput: String = ""
    @State private var selectedColor: Int = 0
    @Binding var show: Bool
    @Binding var location: Location?
    
    let colors = AppColors.tags
    let identifiers = AppColors.tags.ascendingKeys
    
    private var opacity: Double {
        showAdd ? 0 : 1
    }
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                HStack {
                    Spacer()
                    Image(systemName: "tag.fill")
                        .foregroundColor(Color(location!.accent))
                    Text(showAdd ? "MAKE TAG" : "CHOOSE TAG")
                        .tracking(5)
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                        .bold()
                    Spacer()
                    BImage(condition: $showAdd, image: .init(systemName: "plus"))
                        .foregroundColor(.white)
                        .opacity(opacity)
                }
                .padding()
                .offset(y: showAdd ? 400 : 0)
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        ForEach(tags) { tag in
                            ColorTextRow(text: tag.name, color: tag.uiColor)
                                .onTap {
                                    self.setTag(tag: tag)
                            }
                        }
                    }
                }
                .opacity(opacity)
                
                Spacer()
                
                Button(action: {
                    self.show = false
                }) {
                    Text("CLOSE")
                        .font(.title)
                        .foregroundColor(.white)
                }
                .buttonStyle(PlainButtonStyle())
                .frame(maxWidth: .infinity)
            }
            
            VStack {
                TextField("Tag Name...", text: $tagInput)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .multilineTextAlignment(.center)
                    .padding(.init(top: 0, leading: 30, bottom: 0, trailing: 30))
                Picker(selection: $selectedColor, label: Text("Please choose a color")) {
                    ForEach(0..<identifiers.count) {
                        ColorTextRow(text: self.identifiers[$0], color: self.colors[self.identifiers[$0]]!)
                    }
                }
                Button(action: {
                    self.addNewTag()
                }) {
                    Text("DONE")
                }
                Spacer()
            }
            .padding()
            .opacity(showAdd ? 1 : 0)
        }
    }
    
    private func setTag(tag: Tag) {
        location!.setTag(tag: tag)
        show = false
    }
    
    private func addNewTag() {
        let name = tagInput.trimmingCharacters(in: .whitespacesAndNewlines)
        if !name.isEmpty {
            let tag = Tag.create(name: tagInput, color: colors[identifiers[selectedColor]]!)
            location!.setTag(tag: tag)
            show = false
        }
    }
}

struct ColorTextRow: View {
    let text: String
    let color: UIColor
    
    var body: some View {
        HStack {
            Circle()
                .fill(Color(color))
                .frame(width: 20, height: 20)
            Text(text)
                .font(.headline)
                .foregroundColor(.white)
                .lineLimit(nil)
            Spacer()
        }
        .padding(.init(top: 0, leading: 32, bottom: 0, trailing: 0))
    }
}

struct EditTagView_Previews: PreviewProvider {
    static var previews: some View {
        return EditTagView(show: .constant(true), location: .constant(.preview)).environment(\.managedObjectContext, CoreData.stack.context).background(Color.black.edgesIgnoringSafeArea(.all))
    }
}
