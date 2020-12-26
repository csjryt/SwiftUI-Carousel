//
//  ContentView.swift
//  test
//
//  Created by 刘荣盛 on 2020/12/26.
//

import SwiftUI

struct ContentView: View {
    let images: [Image] = (0...7).map{ Image("\($0)") }
    
    @State var lunbo_img_index: Int = 0
    @State var show_img_detail: Bool = false
    
    var body: some View {
        ZStack {
            LunBo(images: images, height: 200, index: $lunbo_img_index)
                .onTapGesture {
                    show_img_detail = true
                }
            
            if show_img_detail {
                ImageDetail(images: images, now_index: $lunbo_img_index)
                    .onTapGesture {
                        show_img_detail = false
                    }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
