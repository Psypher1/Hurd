//
//  LinkViewModel.swift
//  HurdTravel
//
//  Created by clydies freeman on 7/25/23.
//

import Foundation
import LinkPresentation


class LinkViewModel : ObservableObject {
    let metadataProvider = LPMetadataProvider()
    
    @Published var metadata: LPLinkMetadata?
    @Published var image: UIImage?
    
    init(link : String) {
        guard let url = URL(string: link) else {
            return
        }
        metadataProvider.startFetchingMetadata(for: url) { (metadata, error) in
            guard error == nil else {
               // assertionFailure("Error")
                return
            }
            DispatchQueue.main.async {
                self.metadata = metadata
            }
            guard let imageProvider = metadata?.imageProvider else { return }
            imageProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                guard error == nil else {
                    // handle error
                    return
                }
                if let image = image as? UIImage {
                    // do something with image
                    DispatchQueue.main.async {
                        self.image = image
                    }
                } else {
                    print("no image available")
                }
            }
        }
    }
}
