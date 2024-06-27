//
//  InflationDataManager.swift
//  Inflater
//
//  Created by Dylan Elliott on 27/6/2024.
//

import Foundation
import SwiftCSV

struct InflationData {
    typealias Amount = (year: Int, inflation: Double)
    let amounts: [Amount]
}

enum InflationDataDecoder {
    static func decodeCSV(_ csv: CSV<Enumerated>) -> InflationData? {
        let nameRow = csv.rows[3]
        guard let australiaRow = csv.rows.first(where: { $0[0] == "Australia" }) else {
            return nil
        }
        
        let amounts: [InflationData.Amount] = zip(nameRow, australiaRow).compactMap { year, inflation in
            guard let year = Int(year), let inflation = Double(inflation) else {
                return nil
            }
            
            return (year, inflation)
        }
        
        return InflationData(amounts: amounts)
    }
}

extension CSV<Enumerated> {
    func inflationData() -> InflationData? {
        return InflationDataDecoder.decodeCSV(self)
    }
}
class InflationDataManager {
    private let data = (Bundle.main
        .csvFile(named: "API_FP.CPI.TOTL.ZG_DS2_en_csv_v2_637345")?
        .inflationData())!
    
    var startYear: Int { data.amounts.first!.year }
    var endYear: Int { data.amounts.last!.year}
    var count: Int { data.amounts.count }
    
    func amount(for year: Int) -> Double {
        data.amounts.first { $0.year == year }?.inflation ?? 0
    }
    
    func totalInflation(from start: Int, to end: Int) -> Double {
        guard start >= startYear, end <= endYear else { return 0 }
        let startIndex = start - startYear
        let endIndex = startIndex + (end - start)
        let years = data.amounts[startIndex ... endIndex]
        return years.reduce(1.0) { partialResult, amount in
            return partialResult * (1.0 + amount.inflation / 100.0)
        }
    }
}

extension Bundle {
    func csvFile(named name: String) -> CSV<Enumerated>? {
        guard let url = Bundle.main.url(forResource: name, withExtension: "csv") else {
            return nil
        }
        
        do {
            let file = try CSV<Enumerated>(url: url, delimiter: .comma, encoding: .utf8, loadColumns: false)
            return file
        } catch {
            print("Error loading CSV: \(error)")
            return nil
        }
    }
}
