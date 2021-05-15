//
//  SequenceExtension.swift
//  CargoLink
//
//  Created by RAVI KUMAR on 25/06/20.
//  Copyright © 2020 CargoLink. All rights reserved.
//

import Foundation

extension Sequence {
//    func group<U: Hashable>(by key: (Iterator.Element) -> U) -> [[U:[Iterator.Element]]] {
//        return [Dictionary.init(grouping: self, by: key)]
//    }
//    
        func group<GroupingType: Hashable>(by key: (Iterator.Element) -> GroupingType) -> [[Iterator.Element]] {
            var groups: [GroupingType: [Iterator.Element]] = [:]
            var groupsOrder: [GroupingType] = []
            forEach { element in
                let key = key(element)
                if case nil = groups[key]?.append(element) {
                    groups[key] = [element]
                    groupsOrder.append(key)
                }
            }
            return groupsOrder.map { groups[$0]! }
        }
}
