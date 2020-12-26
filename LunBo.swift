//
//  test.swift
//  WoodHome
//
//  Created by 刘荣盛 on 2020/12/25.
//

import SwiftUI

struct LunBo: View {
    private var images: [Image]
    private var height: CGFloat
    private let threshold: CGFloat = 120
    private let width = UIScreen.main.bounds.width
    
    @Binding private var now_img_index: Int
    @State private var local_x_offset: CGFloat = .zero
    
    private var total_x_offset: CGFloat {
        -CGFloat(now_img_index) * width + local_x_offset
    }
    
    private var last_index: Int {
        images.count - 1
    }
    private var pre_index: Int {
        now_img_index == 0 ? last_index : now_img_index - 1
    }
    private var next_index: Int {
        now_img_index == last_index ? 0 : now_img_index + 1
    }

    private var points: some View {
        HStack(spacing: 5) {
            ForEach(0...last_index, id: \.self) { index in
                Circle()
                    .fill(index == now_img_index ? Color.red : Color.white)
                    .frame(width: 5, height: 5)
            }
        }
    }
    
    private var lunbo_drag_gesture: some Gesture {
        DragGesture()
            .onChanged {value in
                local_x_offset = value.translation.width
            }
            .onEnded { value in
                if value.translation.width > threshold {   // 右滑
                    now_img_index = pre_index
                }
                if value.translation.width < -threshold { // 左滑
                    now_img_index = next_index
                }
                local_x_offset = 0
            }
        }
    
    init(images: [Image], height: CGFloat, index: Binding<Int>) {
        self.images = images
        self.height = height
        self._now_img_index = index
    }
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            
            HStack(spacing: 0) {
                ForEach(images.indices, id: \.self) { index in
                    images[index]
                        .resizable()
                        .frame(width: width, height: height)
                        .scaledToFill()
                }
            }
            .offset(x: total_x_offset)
            .gesture( lunbo_drag_gesture )
            .animation(.spring())
            .frame(width: width, height: height, alignment: .leading)
            
            points
                .padding(.bottom, 10)
                .padding(.trailing, 30)
        }
    }
}
