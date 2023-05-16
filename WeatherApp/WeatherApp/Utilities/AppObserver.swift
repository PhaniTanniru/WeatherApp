//
//  AppObserver.swift
//  WeatherApp
//
//  Created by Phanindra Tanniru on 5/16/23.
//

import Foundation

final class AppObserver<T> {
    typealias Listener = (T) -> Void
  
    var listener: Listener?
    var value: T {
        didSet {
            listener?(value)
        }
    }

    init(_ value: T){
        self.value = value
    }

    func bind(listener: Listener?){
        self.listener = listener
    }
    
    func bindAndFire(listener: Listener?) {
        self.listener = listener
        listener?(value)
    }
}
