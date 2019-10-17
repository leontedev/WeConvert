//
//  ContentView.swift
//  WeConvert
//
//  Created by Mihai Leonte on 10/13/19.
//  Copyright © 2019 Mihai Leonte. All rights reserved.
//

import SwiftUI

struct Title: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundColor(.blue)    }
}

extension View {
    func titleStyle() -> some View {
        return self.modifier(Title())
    }
}


struct ContentView: View {
    @State private var input = ""
    
    @State private var convertFrom = 0
    @State private var convertTo = 1
    
    var conversionTypes = ["Temperature", "Distance"]
    @State private var conversionType = 0
    
    var conversions = [
        ["Celsius", "Fahrenheit", "Kelvin"],
        ["km", "feet", "yards", "miles"]
    ]
    var measureUnits = [
        ["°C", "°F", "°K"],
        ["km", " feet", " yards", " miles"]
    ]
    // MARK: Temperature
    // From 0: Celsius, 1: Fahrenheit, 2: Kelvin
    var toCelsiusClosures: [(Double) -> Double] = [{ $0 }, { ($0 - 32) * 5/9 }, { $0-273.15 }]
    // To: 0: Celsis, 1: Fahrenheit, 2: Kelvin
    var fromCelsiusClosures: [(Double) -> Double] = [{ $0 }, { $0 * 9/5 + 32 }, { $0+273.15 }]
    
    // MARK: Distance
    // kilometers, feet, yards, or miles.
    var toMetersClosures: [(Double) -> Double] = [{ $0 * 1000 }, { $0 / 3.281 }, { $0 / 1.094 }, { $0 * 1609.344 }]
    var fromMetersClosures: [(Double) -> Double] = [{ $0 / 1000 }, { $0 * 3.281  }, { $0 * 1.094 }, { $0 / 1609.344 }]
    
    var output: Double {
        guard let input = Double(input) else { return 0 }
        
        if conversionType == 0 {
            // convert to Celsius
            let toCelsius = toCelsiusClosures[convertFrom]
            // convert to Target
            let fromCelsius = fromCelsiusClosures[convertTo]
            return fromCelsius(toCelsius(input))
        } else if conversionType == 1 {
            let toMeters = toMetersClosures[convertFrom]
            let fromMeters = fromMetersClosures[convertTo]
            return fromMeters(toMeters(input))
        } else {
            return 0
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Text("WeConvert").titleStyle()
                
                Form {
                    
                    Section(header: Text("Conversion type")) {
                        Picker("Conversion type", selection: $conversionType) {
                            ForEach(0 ..< conversionTypes.count) {
                                Text("\(self.conversionTypes[$0])")
                            }
                        }.pickerStyle(SegmentedPickerStyle())
                    }
                
                    Section {
                        TextField("Input", text: $input)
                    
                        Picker("Convert From", selection: $convertFrom) {
                            ForEach(0 ..< conversions[conversionType].count, id: \.self) {
                                Text("\(self.conversions[self.conversionType][$0])")
                            }
                        }.pickerStyle(SegmentedPickerStyle())
                    }
                    
                    Section(header: Text("Conversion Result")) {
                        Picker("Convert To", selection: $convertTo) {
                            ForEach(0 ..< conversions[conversionType].count, id: \.self) {
                                Text("\(self.conversions[self.conversionType][$0])")
                            }
                        }.pickerStyle(SegmentedPickerStyle())
                        
                        Text("\(output, specifier:"%.1f")\(measureUnits[conversionType][convertTo])")
                    }
                    
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
