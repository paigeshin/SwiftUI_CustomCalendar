# SwiftUI_CustomCalendar
```swift

//
//  CustomDataPicker.swift
//  SwiftUI Calendar
//
//  Created by paige on 2022/04/04.
//

import SwiftUI

// MARK: DATE VALUE MODEL
struct DateValue: Identifiable {
    var id: String = UUID().uuidString
    var day: Int
    var date: Date
}


struct CustomDataPicker: View {
    
    @Binding var currentDate: Date
    
    // MARK: Month Update On Arrow Button Clicks...
    @State private var currentMonth: Int = 0
    
    var body: some View {
        
        VStack(spacing: 35) {
            
            // MARK: Days...
            let days: [String] = [
                "Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"
            ]
            
            HStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 10) {
                    
                    Text(extraDate()[0])
                        .font(.caption)
                        .fontWeight(.semibold)
                
                    Text(extraDate()[1])
                        .font(.title.bold())
                } //: VSTACK
                
                Spacer(minLength: 0)
                
                Button {
                    withAnimation {
                        currentMonth -= 1
                    }
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                } //: BUTTON
                
                Button {
                    withAnimation {
                        currentMonth += 1
                    }
                } label: {
                    Image(systemName: "chevron.right")
                        .font(.title2)
                } //: BUTTON
                
            } //: HSTACK
            .padding(.horizontal)
            
            // MARK: Day View...
            HStack(spacing: 0) {
                ForEach(days, id: \.self) { day in
                    Text(day)
                        .font(.callout)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                }
            } //: HSTACK
            
            // MARK: Dates...
            // Lazy Grid...
            let columns: [GridItem] = Array(repeating: GridItem(.flexible()), count: 7)
            LazyVGrid(columns: columns, spacing: 15) {
                ForEach(extractDate()) { dateValue in
                    CardView(value: dateValue)
                }
            } //: LAZYVRID
        } //: VSTACK
        .onChange(of: currentMonth) { newValue in
            // updating month...
            currentDate = getCurrentMonth()
        }
    }
    
    @ViewBuilder
    private func CardView(value: DateValue) -> some View {
        VStack {
            if value.day != -1 {
                
                Text("\(value.day)")
                    .font(.title3.bold())
      
            }
        }
        .padding(.vertical, 8)
        .frame(height: 60, alignment: .top)
    }
    
    // extracting Year and Month for display....
    private func extraDate() -> [String] {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "YYYY MMMM"
        let date: String = formatter.string(from: currentDate)
        return date.components(separatedBy: " ")
    }
    
    private func getCurrentMonth() -> Date {
        let calendar: Calendar = Calendar.current
        // Getting Current Month Date...
        guard let currentMonth = calendar.date(byAdding: .month, value: self.currentMonth, to: Date()) else {
            return Date()
        }
        return currentMonth
    }
    
    // MARK: EXTRACT DATE
    private func extractDate() -> [DateValue] {
        
        let calendar: Calendar = Calendar.current
        
        // Getting Current Month Date...
        let currentMonth = getCurrentMonth()
        
        var days: [DateValue] = currentMonth.getAllDates().compactMap { date -> DateValue in
            // getting day...
            let day: Int = calendar.component(.day, from: date)
            return DateValue(day: day, date: date)
        }
        
        // adding offset days to get exact week day...
        let firstWeekday: Int = calendar.component(.weekday, from: days.first?.date ?? Date())
        
        for _ in 0..<firstWeekday - 1 {
            days.insert(DateValue(day: -1, date: Date()), at: 0)
        }
        
        return days
    }
    
}

struct CustomDataPicker_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

// Extending Date to get Current Month Dates...
fileprivate extension Date {
    
    func getAllDates() -> [Date] {
        let calendar: Calendar = Calendar.current
        
        // getting start date...
        let startDate: Date = calendar.date(from: Calendar.current.dateComponents([.year, .month], from: self))!
        
        let range: Range<Int> = calendar.range(of: .day, in: .month, for: startDate)!
        
        // getting date
        return range.compactMap { day -> Date in
            return calendar.date(byAdding: .day, value: day - 1, to: startDate)!
        }
    }
    
}



```