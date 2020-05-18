//
//  ScenarioOneMapper.swift
//  MVVMArchitecture
//
//  Created by Armand Kamffer on 2020/04/09.
//  Copyright © 2020 Armand Kamffer. All rights reserved.
//

import Foundation

class ScenarioThreeMapper {
    static func mapGroups(with response: ScenarioThreeResponse?) -> [ScenarioThreeGroup] {
        guard let response = response else {
            return []
        }
        var groups = [ScenarioThreeGroup]()
        if let summaryGroup = mapSummaryGroup(with: response) {
            groups.append(summaryGroup)
        }
        groups.append(mapDetailGroup(with: response))
        groups.append(mapMoreDetailGroup(with: response))
        return groups
    }
    
    static func mapSummaryGroup(with response: ScenarioThreeResponse) -> ScenarioThreeGroup? {
        guard let totalCost = response.totalCost else {
            return nil
        }
        let totalCostText = totalCost.currency ?? .placeholder
        let item = ScenarioThreeItem(title: .allBenefits, cost: totalCostText, type: .info)
        return ScenarioThreeGroup(type: .summary, title: .summary, description: nil, items: [item])
    }
    
    static func mapDetailGroup(with response: ScenarioThreeResponse) -> ScenarioThreeGroup {
        let items = response.detail.map {
            ScenarioThreeItem(title: $0.title, cost: $0.cost.currency ?? .placeholder, type: .description)
        }
        return ScenarioThreeGroup(type: .detail, title: .detail, description: .detailDescription, items: items)
    }
    
    static func mapMoreDetailGroup(with response: ScenarioThreeResponse) -> ScenarioThreeGroup {
        var isInfo = false
        let items: [ScenarioThreeItem] = response.detail.map {
            let type: ScenarioThreeItemType = isInfo ? .info : .description
            isInfo.toggle()
            return ScenarioThreeItem(title: $0.title, cost: $0.cost.currency ?? .placeholder, type: type)
        }
        return ScenarioThreeGroup(type: .moreDetail, title: nil, description: nil, items: items)
    }
}

fileprivate extension String {
    static let allBenefits = "All benefits"
    static let summary = "Summary"
    static let detail = "Detail"
    static let detailDescription = "The following is a breakdown of your benefit costs"
    static let placeholder = "-"
}


enum ScenarioThreeGroupType {
    case summary
    case detail
    case moreDetail
}

enum ScenarioThreeItemType {
    case info
    case description
}

class ScenarioThreeGroup {
    var type: ScenarioThreeGroupType
    var title: String?
    var description: String?
    var items: [ScenarioThreeItem]
    
    init(type: ScenarioThreeGroupType, title: String?, description: String?, items: [ScenarioThreeItem]) {
        self.type = type
        self.title = title
        self.items = items
        self.description = description
    }
}

class ScenarioThreeItem {
    var type: ScenarioThreeItemType
    var title: String
    var cost: String
    
    init(title: String, cost: String, type: ScenarioThreeItemType) {
        self.title = title
        self.cost = cost
        self.type = type
    }
}
