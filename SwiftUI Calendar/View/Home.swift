//
//  Home.swift
//  SwiftUI Calendar
//
//  Created by paige on 2022/04/04.
//

import SwiftUI

struct Home: View {
    
    @State var currentDate: Date = Date()
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 20) {
                
                // Custom Date Picker
                CustomDataPicker(currentDate: $currentDate)
                
            }
        }
    }
    
}


struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
