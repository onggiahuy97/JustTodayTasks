//
//  EndEditting.swift
//  JustTodayTasks
//
//  Created by Huy Ong on 8/7/20.
//

import SwiftUI

extension View {
    func endEditting() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
