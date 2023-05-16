//
//  NoDataView.swift
//  WeatherApp
//
//  Created by Phanindra Tanniru on 5/16/23.
//

import Foundation
import UIKit

class NoDataView: UIView {
        // MARK: - IBOutlet
        @IBOutlet private weak var contentView: UIView!
        @IBOutlet private weak var lblNoData: UILabel!

        override init(frame: CGRect) {
            super.init(frame: frame)
        }
        
        func setupNoDataView()
        {
            contentView.removeFromSuperview()
            addSubview(contentView)
            lblNoData.text = WeatherAppConstants.noLocationFound
        }
        
        func setupSelectLocation(){
            contentView.removeFromSuperview()
            addSubview(contentView)
            lblNoData.text = WeatherAppConstants.selectLocation
        }
    

        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }

        private func commonInit() {
            UIView.fromNib()
            lblNoData.text = WeatherAppConstants.noLocationFound
            addSubview(contentView)
        }
}

