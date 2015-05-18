//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Aldin Fajic on 5/14/15.
//  Copyright (c) 2015 Aldin Fajic. All rights reserved.
//

import Foundation

final class RecordedAudio: NSObject {
    var filePathUrl: NSURL!
    var title: String!
    
    init(filePathUrl: NSURL, title: String) {
        self.filePathUrl = filePathUrl
        self.title = title
    }
}