//
//  ScrollViewWithUpdates.swift
//  Machac
//
//  Created by Jan on 19/10/2017.
//  Copyright © 2017 Schwarja. All rights reserved.
//

import UIKit

protocol ScrollViewUpdateDelegate: class {
    func contentSizeDidChange(_ scrollView: UIScrollView, contentSize: CGSize)
}

class TableViewWithUpdates: UITableView {
    
    weak var updateDelegate: ScrollViewUpdateDelegate?

    override var contentSize: CGSize {
        didSet {
            if oldValue != contentSize {
                updateDelegate?.contentSizeDidChange(self, contentSize: contentSize)
            }
        }
    }

}
