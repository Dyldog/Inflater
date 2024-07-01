//
//  ContentView.swift
//  Inflater
//
//  Created by Dylan Elliott on 27/6/2024.

import SwiftUI

struct IntSlider: View {
    let value: Binding<Int>
    let range: ClosedRange<Int>
    let onEditingChanged: (Bool) -> Void

    init(
        value: Binding<Int>,
        in range: ClosedRange<Int>,
        onEditingChanged: @escaping (Bool) -> Void = { _ in }
    ) {
        self.value = value
        self.range = range
        self.onEditingChanged = onEditingChanged
    }

    var body: some View {
        Slider(
            value: .init(get: {
                Double(value.wrappedValue)
            }, set: { new in
                value.wrappedValue = Int(new.rounded())
            }),
            in: Double(range.lowerBound) ... Double(range.upperBound),
            onEditingChanged: onEditingChanged
        )
    }
}

struct ContentView: View {
    let inflationManager: InflationDataManager

    @State var pastAmount: Int
    @State var startYear: Int

    var endYear: Int { inflationManager.endYear }

    var currentInflation: Double {
        inflationManager.totalInflation(from: startYear, to: endYear)
    }

    var currentAmount: Double {
        Double(pastAmount) * currentInflation
    }

    var amountFormatter: NumberFormatter {
        let format = NumberFormatter()
        format.numberStyle = .currency
        return format
    }

    var yearFormatter: NumberFormatter {
        let format = NumberFormatter()
        format.minimum = inflationManager.startYear as NSNumber
        format.maximum = inflationManager.endYear as NSNumber
        return format
    }

    init(dataManager: InflationDataManager) {
        inflationManager = dataManager
        pastAmount = 1
        startYear = inflationManager.startYear
    }

    var body: some View {
        VStack(alignment: .center) {
            HStack {
                TextField("Past Amount", value: $pastAmount, formatter: amountFormatter)
                    .frame(minWidth: 0)
                Text(formatted("in"))
            }

            HStack {
                TextField("Start Year", value: $startYear, formatter: yearFormatter)
                Text(formatted("money"))
            }

            JustifiedText(formatted("is \(amountFormatter.string(from: currentAmount as NSNumber)!) in"))

            JustifiedText(formatted("\(endYear) money"))
        }
        .font(.largeTitle)
        .fontWeight(.bold)
        .textFieldStyle(.roundedBorder)
        .padding()
        .padding(.horizontal, 30)
    }

    func formatted(_ text: String) -> String {
        text.uppercased()
    }
}

#Preview {
    ContentView(dataManager: .init())
}
