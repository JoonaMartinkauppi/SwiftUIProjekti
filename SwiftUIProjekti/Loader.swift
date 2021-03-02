//
//  Loader.swift
//  SwiftUIProjekti
//
//  Created by Joona Martinkauppi on 1.3.2021.
//

import Foundation
import Combine

public class DataLoader: ObservableObject {

    public let objectWillChange = PassthroughSubject<Data,Never>()

    public private(set) var data = Data() {
        willSet {
            objectWillChange.send(newValue)
        }
    }
    let apiURL = "https://external.api.yle.fi/v1/teletext/images/102/1.png?app_id=b85be5bb&app_key=c3ee4db2abe12bf33675905913741982"
    private let resourseURL: URL?

    public init(resourseURL: URL?){
        self.resourseURL = resourseURL
    }

    public func loadImage() {
        guard let url = resourseURL else {
            return
        }

        URLSession.shared.dataTask(with: url) { (data,_,_) in
            guard let data = data else {
                return
            }
            DispatchQueue.main.async {
                self.data = data
            }
        }   .resume()
    }
}
