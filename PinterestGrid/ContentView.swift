//
//  ContentView.swift
//  PinterestGrid
//
//  Created by Ayhan on 5.06.2022.
//

import SwiftUI

struct ContentView: View {
    let gridItems = [
        GridItem(height: 450, imgString: "1"),
        GridItem(height: 243, imgString: "2"),
        GridItem(height: 353, imgString: "3"),
        GridItem(height: 352, imgString: "4"),
        GridItem(height: 300, imgString: "5"),
        GridItem(height: 352, imgString: "6"),
        GridItem(height: 334, imgString: "7"),
        GridItem(height: 115, imgString: "8"),
        GridItem(height: 313, imgString: "9"),
        GridItem(height: 288, imgString: "10"),
        GridItem(height: 252, imgString: "11"),
        GridItem(height: 119, imgString: "12"),
        GridItem(height: 211, imgString: "1"),
        GridItem(height: 341, imgString: "14"),
        GridItem(height: 179, imgString: "15")
    ]
    
    @State private var columns = 3
    var body: some View {
        NavigationView{
            ScrollView{
                  PinterestGrid(gridItems: gridItems, numOfColumns: columns, spacing: 13, horizontalPadding: 10)
              }
            .navigationBarItems(leading: removeBtn ,trailing: addBtn)
            .navigationTitle("Pinterest Grid")
        }
    }
    var removeBtn: some View{
        Button(action: {
            columns -= 1
        }){
            Text("Remove")
        }
        .disabled(columns == 1)
    }
    
    var addBtn: some View{
        Button(action: {
            columns += 1
        }){
            Text("Add")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}
//
//  PinterestGrid.swift
//  PinterestGrid
//
//  Created by Ayhan on 5.06.2022.
//

import SwiftUI

struct GridItem: Identifiable{
    let id = UUID()
    let height: CGFloat
    let imgString: String
}

struct PinterestGrid: View {
    struct Column: Identifiable{
        let id = UUID()
        var gridItems = [GridItem]()
    }
    let columnss: [Column]
    
    let spacing: CGFloat
    let horizontalPadding: CGFloat
    
    init(gridItems: [GridItem], numOfColumns: Int, spacing: CGFloat = 20, horizontalPadding: CGFloat = 20){
        self.spacing = spacing
        self.horizontalPadding = horizontalPadding
        
        var columnss = [Column]()
        for _ in 0 ..< numOfColumns {
            columnss.append(Column())
        }
        
        var columnsHeight = Array<CGFloat>(repeating: 0, count: numOfColumns)
        
        for gridItem in gridItems {
            var smallestColumnIndex = 0
            var smallestHeight = columnsHeight.first!
            for i in 1 ..< columnsHeight.count{
                let curHeight = columnsHeight[i]
                if curHeight < smallestHeight {
                    smallestHeight = curHeight
                    smallestColumnIndex = i
                }
            }
            
            columnss[smallestColumnIndex].gridItems.append(gridItem)
            columnsHeight[smallestColumnIndex] += gridItem.height
        }
        self.columnss = columnss
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: spacing){
            ForEach(columnss){ column in
                LazyVStack(spacing: spacing){
                    ForEach(column.gridItems) { gridItme in
                        
                        getItemView(gridItem: gridItme)
                    }
                }
                
            }
            
        }
        .padding(.horizontal, horizontalPadding)
    }
    func getItemView(gridItem: GridItem) -> some View{
        ZStack{
            GeometryReader{ reader in
                Image(gridItem.imgString)
                    .resizable()
                    .scaledToFill()
                    .frame(width: reader.size.width, height: reader.size.height,alignment: .center)
            }
        }
        .frame(height: gridItem.height)
        .frame(maxWidth: .infinity)
        .clipShape(RoundedRectangle(cornerRadius: 13))
    }
}

struct PinterestGrid_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
