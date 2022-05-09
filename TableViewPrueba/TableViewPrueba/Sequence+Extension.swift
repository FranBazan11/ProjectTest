//
//  Sequence+Extension.swift
//  TableViewPrueba
//
//  Created by francisco bazan on 10/21/20.
//  Copyright © 2020 Juan Francisco Bazán Carrizo. All rights reserved.
//

import Foundation

extension Sequence where Iterator.Element == (MarketplaceSection) {
    func mapSectionListToIternalSection() -> [MarketPlaceTableViewSection] {
        var allSections: [MarketPlaceTableViewSection] = []
        var tableViewSection: MarketPlaceTableViewSection = MarketPlaceTableViewSection(header: nil, items: [])
        for section in self {
            if section.pinned  {
                allSections.append(tableViewSection)
                tableViewSection = MarketPlaceTableViewSection(header: section, items: [])
            } else {
                tableViewSection.items.append(section)
            }
        }
        allSections.append(tableViewSection)
        
        return allSections
    }
}
