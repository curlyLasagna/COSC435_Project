//
//  FlowLayout.swift
//  nVolve
//
//  Created by Abdalla Abdelmagid on 11/11/24.

import SwiftUI

struct FlowLayoutView: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = FlowResult(in: proposal.width ?? 0, subviews: subviews, spacing: spacing)
        return result.size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = FlowResult(in: bounds.width, subviews: subviews, spacing: spacing)
        for (index, line) in result.lines.enumerated() {
            let y = bounds.minY + result.lineOffsets[index]
            var x = bounds.minX

            for item in line {
                let width = item.sizeThatFits(.unspecified).width
                item.place(at: CGPoint(x: x, y: y), proposal: .unspecified)
                x += width + spacing
            }
        }
    }

    struct FlowResult {
        var lines: [[LayoutSubview]] = [[]]
        var lineOffsets: [CGFloat] = [0]
        var size: CGSize = .zero

        init(in maxWidth: CGFloat, subviews: LayoutSubviews, spacing: CGFloat) {
            var currentX: CGFloat = 0
            var currentY: CGFloat = 0
            var currentLineHeight: CGFloat = 0

            for subview in subviews {
                let size = subview.sizeThatFits(.unspecified)

                if currentX + size.width > maxWidth && !lines[lines.count - 1].isEmpty {
                    currentX = 0
                    currentY += currentLineHeight + spacing
                    currentLineHeight = 0
                    lines.append([])
                    lineOffsets.append(currentY)
                }

                lines[lines.count - 1].append(subview)
                currentLineHeight = max(currentLineHeight, size.height)
                currentX += size.width + spacing

                self.size.width = max(self.size.width, currentX)
            }

            self.size.height = currentY + currentLineHeight
        }
    }
}
