//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Jakub on 13.06.15.
//  Copyright (c) 2015 Jakub Jozefek. All rights reserved.
//

import Foundation

class RecordedAudio {
    
    var filePathUrl: NSURL!
    var title: String!
    
    init(url: NSURL, title: String) {
        self.filePathUrl = url
        self.title = title
    }
    
}