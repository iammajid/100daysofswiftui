//
//  ContentView.swift
//  Unit Converter
//
//  Created by Majid Achhoud on 02.11.23.
//

import SwiftUI

struct ContentView: View {
    @State private var temperatureValue = 0.0
    @State private var inputUnit = 0
    @State private var outputUnit = 0
    @FocusState private var temperatureIsFocused: Bool
    
    let temperatureUnits = ["Celsius", "Fahrenheit", "Kelvin"]
    
    var convertedTemperature: Double {
        switch temperatureUnits[inputUnit] {
        case "Celsius":
            switch temperatureUnits[outputUnit] {
            case "Fahrenheit":
                return temperatureValue * 9/5 + 32
            case "Kelvin":
                return temperatureValue + 273.15
            default:
                return temperatureValue
            }
        case "Fahrenheit":
            switch temperatureUnits[outputUnit] {
            case "Celsius":
                return (temperatureValue - 32) * 5/9
            case "Kelvin":
                return (temperatureValue - 32) * 5/9 + 273.15
            default:
                return temperatureValue
            }
        case "Kelvin":
            switch temperatureUnits[outputUnit] {
            case "Celsius":
                return temperatureValue - 273.15
            case "Fahrenheit":
                return (temperatureValue - 273.15) * 9/5 + 32
            default:
                return temperatureValue
            }
        default:
            return temperatureValue
        }
    }
    
    var body: some View {
        NavigationView {
            Form {
                
                Section("Input Unit") {
                    Picker("Select input unit", selection: $inputUnit) {
                        ForEach(temperatureUnits.indices, id: \.self) {
                            Text(temperatureUnits[$0])
                        }
                        
                    }
                    .pickerStyle(.segmented)
                }
                
                Section {
                    TextField("Temperature", value: $temperatureValue, format: .number)
                        .keyboardType(.decimalPad)
                        .focused($temperatureIsFocused)
                }
                
                Section("Output Unit") {
                    Picker("Select output unit", selection: $outputUnit) {
                        ForEach(temperatureUnits.indices, id: \.self) {
                            Text(temperatureUnits[$0])
                        }
                        
                    }
                    .pickerStyle(.segmented)
                }
                
                Section("Converted Temperature") {
                    Text("\(convertedTemperature, specifier: "%.2f") \(temperatureUnits[outputUnit])")
                }
            }
            .navigationTitle("Temperature Converter")
            .toolbar {
                if temperatureIsFocused {
                    Button("Done") {
                        temperatureIsFocused = false
                    }
                }
            }
        }
    }
}


#Preview {
    ContentView()
}
