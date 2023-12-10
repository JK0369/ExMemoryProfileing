//
//  ViewController.swift
//  ExImageIO
//
//  Created by 김종권 on 2023/12/10.
//

import UIKit

class ViewController: UIViewController {
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        guard let url = URL(string: "https://cdn.pixabay.com/photo/2023/11/30/07/51/bridge-8420945_1280.jpg") else { return }
        downloadImageData(from: url) { [weak self] data in
            guard let data else { return }
            DispatchQueue.main.async {
                self?.imageView.image = UIImage(data: data)
            }
        }
    }
    
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
