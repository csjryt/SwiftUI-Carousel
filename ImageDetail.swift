//
//  ImageDetail.swift
//  WoodHome
//
//  Created by 刘荣盛 on 2020/12/25.
//

import SwiftUI

struct ImageDetail: View {
    private var images: [Image]
    
    private var last_index: Int {
        images.count - 1
    }
    
    private let threshold: CGFloat = 120
    private let screen_width = UIScreen.main.bounds.width
    
    private var frame_width: CGFloat {
        screen_width * now_scale
    }
    
    private var bigger_threshold: CGFloat {
        (frame_width - screen_width) / 2 + threshold
    }
    
    @Binding private var now_index: Int
    
    private var pre_index: Int {
        now_index == 0 ? last_index : now_index - 1
    }
    
    private var next_index: Int {
        now_index == last_index ? 0 : now_index + 1
    }
    
    @State private var now_scale: CGFloat = 1
    @State private var pre_scale: CGFloat = 1
    
    @State private var now_x_offset: CGFloat = 0
    @State private var pre_x_offset: CGFloat = 0
    
    private var double_tap: some Gesture {
        TapGesture(count: 2)
            .onEnded{
                if now_scale == 1 {
                    now_scale = 2
                    pre_scale = 2
                }
                else {
                    now_scale = 1
                    pre_scale = 1
                }
                now_x_offset = 0
                pre_x_offset = 0
            }
    }
    
    private var drag: some Gesture {
        DragGesture()
            .onChanged {value in
                if now_scale == 1 {
                    now_x_offset = value.translation.width
                }
                else {
                    now_x_offset = pre_x_offset + value.translation.width
                }
            }
            .onEnded { value in
                if now_scale == 1 {
                    if abs(now_x_offset) <= threshold {
                        now_x_offset = 0
                        pre_x_offset = 0
                    }
                    else {
                        do_change()
                    }
                }
                else {
                    if abs(now_x_offset) >= bigger_threshold {
                        do_change()
                    }
                    else if abs(now_x_offset) <= (frame_width - screen_width) / 2 {
                        pre_x_offset = now_x_offset
                    }
                    else {
                        if now_x_offset < 0 {
                            now_x_offset = -(frame_width - screen_width) / 2
                            pre_x_offset = now_x_offset
                        }
                        else {
                            now_x_offset = (frame_width - screen_width) / 2
                            pre_x_offset = now_x_offset
                        }
                    }
                    
                }
            }
    }
    
    private var scaling: some Gesture {
        MagnificationGesture()
            .onChanged { scale in
                now_scale = pre_scale * scale
            }
            .onEnded { scale in
                if now_scale <= 1 {
                    now_scale = 1
                    pre_x_offset = 0
                    now_x_offset = 0
                }
                pre_scale = now_scale
            }
    }
    
    private func do_change() { // 现在的过渡不自然，还需要优化
        if now_x_offset > 0 { // 右滑
            now_index = (now_index == 0 ? last_index : now_index - 1)
        }
        else {  // 左滑
            now_index = (now_index == last_index ? 0 : now_index + 1)
        }
        now_scale = 1
        pre_scale = 1
        now_x_offset = 0
        pre_x_offset = 0
    }
    
    init(images: [Image], now_index: Binding<Int>) {
        self.images = images
        self._now_index = now_index
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.black)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
            
            HStack(spacing: 0) {
                images[pre_index]
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width)
                    .offset(x: now_x_offset)
                
                images[now_index]
                    .resizable()
                    .scaledToFit()
                    .scaleEffect(now_scale >= 1 ? 1 : now_scale)
                    .frame(width: now_scale >= 1 ? frame_width : screen_width)
                    .offset(x: now_x_offset)
                    .gesture(double_tap)
                    .gesture(drag)
                    .gesture(scaling)
                    
                images[next_index]
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width)
                    .offset(x: now_x_offset)
                
            }
            .animation(.default, value: now_scale)
            .frame(width: screen_width, alignment: .center)
        }
    }
}
