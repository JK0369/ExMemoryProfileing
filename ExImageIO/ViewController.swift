//
//  ViewController.swift
//  ExImageIO
//
//  Created by 김종권 on 2023/12/10.
//

import UIKit
import ImageIO

class ViewController: UIViewController {
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let url = URL(string: "https://cdn.pixabay.com/photo/2023/11/30/07/51/bridge-8420945_1280.jpg")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        downloadWithResizeV1()
        downloadWithResizeV2()
    }
    
    func downloadWithResizeV1() {
        downloadImageData(from: url) { [weak self] data in
            guard let data, let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self?.imageView.image = image
            }
            
            // resizing image
            let scale = 0.2
            let size = CGSize(width: image.size.width * scale, height: image.size.height * scale)
            let renderer = UIGraphicsImageRenderer(size: size)
            let renderedImage = renderer.image { _ in
                image.draw(in: .init(origin: .zero, size: size))
            }
            DispatchQueue.main.async {
                self?.imageView.image = renderedImage
            }
        }
    }
    
    func downloadWithResizeV2() {
        let imageSource = CGImageSourceCreateWithURL(url as CFURL, nil)!
        let properties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil)
        let options: [CFString : Any] = [
            kCGImageSourceThumbnailMaxPixelSize: 100,
            kCGImageSourceCreateThumbnailFromImageAlways: true
        ]
        let scaledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, options as CFDictionary)!
        let image = UIImage(cgImage: scaledImage)
        imageView.image = image
    }
}

private extension ViewController {
    func downloadImageData(from url: URL, completion: @escaping (Data?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            completion(data)
        }.resume()
    }
}
