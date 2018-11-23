//
//  ExportManager.swift
//  Machac
//
//  Created by Jan on 19/10/2017.
//  Copyright © 2017 Schwarja. All rights reserved.
//

import Foundation

struct CSV {
    private var content = ""
    private var currentLine = ""
    
    var string: String {
        if content.isEmpty {
            return currentLine
        }
        else {
            return "\(content)\n\(currentLine)"
        }
    }
    
    mutating func newLine() {
        if content.isEmpty {
            content = currentLine
        }
        else {
            content += "\n\(currentLine)"
        }
        currentLine = ""
    }
    
    mutating func add(column: String) {
        let normalizedColumn = "\"\(column)\""
        if currentLine.isEmpty {
            currentLine = normalizedColumn
        }
        else {
            currentLine += "\t\(normalizedColumn)"
        }
    }
    
    mutating func add(doubleColumn double: Double) {
        add(column: String(format: "%g", double))
    }
}

class ExportManager {
    let realmManager: RealmManager
    
    init(realmManager: RealmManager) {
        self.realmManager = realmManager
    }
    
    func exportCosts(forPerson person: Person) throws -> URL? {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        guard let directory = paths.first else {
            return nil
        }
        
        let filename = "\(directory)/Export-\(person.name)-\(person.id).tsv"
        
        try export(forPerson: person, toFile: filename)
        
        return URL(fileURLWithPath: filename)
    }
    
}

private extension ExportManager {
    
    func export(forPerson person: Person, toFile filename: String) throws {
        let fileManager = FileManager.default
        try? fileManager.removeItem(atPath: filename)
        
        let content = exportContent(forPerson: person)
        
        try content.write(toFile: filename, atomically: false, encoding: .utf8)
    }
    
    func exportContent(forPerson person: Person) -> String {
        let people = realmManager.people(without: person)
        
        var csv = CSV()
        
        csv.add(column: "Paid for items")
        csv.newLine()
        
        csv.add(column: "Item")
        csv.add(column: "Price")
        for prs in people {
            csv.add(column: prs.name)
        }
        csv.newLine()
        
        for item in person.items {
            csv.add(column: item.name)
            csv.add(doubleColumn: item.value(with: realmManager.settings.referenceCurrency))
            
            for prs in people {
                let ratio = item.ratios.find(predicate: { $0.debtor?.id == prs.id })?.ratio ?? 0
                csv.add(doubleColumn: ratio)
            }
            
            csv.newLine()
        }
        
        csv.add(column: "")
        csv.add(doubleColumn: person.items.reduce(0, { $0 + $1.value(with: realmManager.settings.referenceCurrency) }))
        for prs in people {
            csv.add(doubleColumn: person.wantsFrom(person: prs))
        }
        csv.newLine()
        
        csv.newLine()
        
        csv.add(column: "Owes for items")
        csv.newLine()
        
        csv.add(column: "Item")
        csv.add(column: "Price")
        for prs in people {
            csv.add(column: prs.name)
        }
        csv.add(column: "Debt")
        csv.newLine()
        
        for ratio in person.ratios {
            csv.add(column: ratio.item?.name ?? "")
            csv.add(doubleColumn: ratio.item?.value(with: realmManager.settings.referenceCurrency) ?? 0)
            
            for prs in people {
                if ratio.item?.owner?.id == prs.id {
                    csv.add(doubleColumn: ratio.ratio)
                }
                else {
                    csv.add(doubleColumn: 0)
                }
            }
            
            csv.add(doubleColumn: ratio.ratio * (ratio.item?.value(with: realmManager.settings.referenceCurrency) ?? 0))
            
            csv.newLine()
        }

        csv.add(column: "")
        csv.add(column: "")
        for prs in people {
            csv.add(doubleColumn: person.owesTo(person: prs))
        }
        csv.add(doubleColumn: person.owes)
        csv.newLine()

        csv.newLine()
        
        csv.add(column: "Total is owed")
        csv.newLine()
        for prs in people {
            csv.add(column: prs.name)
        }
        csv.newLine()
        for prs in people {
            let income = person.wantsFrom(person: prs) - person.owesTo(person: prs)
            csv.add(doubleColumn: max(0, income))
        }
        csv.newLine()

        csv.newLine()

        csv.add(column: "Total owes")
        csv.newLine()
        for prs in people {
            csv.add(column: prs.name)
        }
        csv.newLine()
        for prs in people {
            let debt = person.owesTo(person: prs) - person.wantsFrom(person: prs)
            csv.add(doubleColumn: max(0, debt))
        }
        csv.newLine()

        return csv.string
    }
    
}
