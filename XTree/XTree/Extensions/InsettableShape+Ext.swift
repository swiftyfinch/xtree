//
//  InsettableShape+Ext.swift
//  XTree
//
//  Created by Ivan Glushko on 13.05.2024.
//

import SwiftUI

extension InsettableShape {
    
    /// Applies back deployed modifers for stroking border
    @inlinable func customStrokeBorderAndFill() -> some View {
        let colorView = Color.white.opacity(0.03)
        let strokeStyle = StrokeStyle(dash: [4])
        
        if #available(macOS 14.0, *) {
            return self.strokeBorder(HierarchicalShapeStyle.tertiary, style: strokeStyle).fill(colorView)
        } else {
            // Fill modifier is not available for type: any View
            return self.strokeBorder(HierarchicalShapeStyle.tertiary, style: strokeStyle)
        }
    }
}
