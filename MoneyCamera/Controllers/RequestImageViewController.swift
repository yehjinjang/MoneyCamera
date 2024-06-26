//
//  ViewController.swift
//  MoneyCamera
//
//  Created by wonyoul heo on 6/4/24.
//

import UIKit
import Photos

class RequestImageViewController: UIViewController {
    let visionObjectRecognitionModel = VisionObjectRecognition.shared
    
    private lazy var lensLogoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "moneylensIcon")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "MoneyLens"
        titleLabel.font = UIFont(name: "Pretendard-Bold", size: 40)
        titleLabel.textColor = UIColor(named: "buttonIconColor_green")
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let subtitleLabel = UILabel()
        subtitleLabel.text = "Likelion LAB7"
        subtitleLabel.font = UIFont(name: "Pretendard-Bold", size: 8)
        subtitleLabel.textColor = UIColor(named: "subtitleColor")
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        return subtitleLabel
    }()
    
    private lazy var buttonContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.distribution = .equalCentering
        stackView.alignment = .center
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var cameraButton: UIButton = {
        let button = UIButton(type: .custom)
        var config = UIButton.Configuration.filled()
        let imageConfiguration = UIImage.SymbolConfiguration(pointSize: 20)
        config.image = UIImage(systemName: "camera.fill", withConfiguration: imageConfiguration)
        config.baseBackgroundColor = .white
        config.baseForegroundColor = UIColor(named: "buttonIconColor_green")
        config.cornerStyle = .capsule
        button.configuration = config
        button.addTarget(self, action: #selector(cameraTapped), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 60),
            button.heightAnchor.constraint(equalToConstant: 60)
        ])
        return button
    }()
    
    private lazy var albumButton: UIButton = {
        let button = UIButton(type: .custom)
        var config = UIButton.Configuration.filled()
        let imageConfiguration = UIImage.SymbolConfiguration(pointSize: 20)
        config.image = UIImage(systemName: "photo.fill", withConfiguration: imageConfiguration)
        config.baseBackgroundColor = .white
        config.baseForegroundColor = UIColor(named: "buttonIconColor_green")
        button.configuration = config
        button.layer.cornerRadius = 30
        button.layer.masksToBounds = true
        
        button.addTarget(self, action: #selector(albumTapped), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 60),
            button.heightAnchor.constraint(equalToConstant: 60)
        ])
        return button
    }()
    
    private lazy var historyButton: UIButton = {
        let button = UIButton(type: .custom)
        var config = UIButton.Configuration.filled()
        let imageConfiguration = UIImage.SymbolConfiguration(pointSize: 20)
        config.image = UIImage(systemName: "list.bullet", withConfiguration: imageConfiguration)
        config.baseBackgroundColor = .white
        config.baseForegroundColor = UIColor(named: "buttonIconColor_green")
        button.configuration = config
        button.layer.cornerRadius = 30
        button.layer.masksToBounds = true
        
        button.addTarget(self, action: #selector(historyTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 60),
            button.heightAnchor.constraint(equalToConstant: 60)
        ])
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "backgroundColor_green")
        
        buttonContainer.addArrangedSubview(cameraButton)
        buttonContainer.addArrangedSubview(albumButton)
        buttonContainer.addArrangedSubview(historyButton)
        
        view.addSubview(lensLogoImageView)
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(buttonContainer)
        
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            lensLogoImageView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            lensLogoImageView.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor, constant: -100),
            lensLogoImageView.widthAnchor.constraint(equalToConstant: 280),
            lensLogoImageView.heightAnchor.constraint(equalToConstant: 280),
            
            titleLabel.centerXAnchor.constraint(equalTo: lensLogoImageView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: lensLogoImageView.centerYAnchor),
            
            subtitleLabel.trailingAnchor.constraint(equalTo: lensLogoImageView.trailingAnchor, constant: -33),
            subtitleLabel.bottomAnchor.constraint(equalTo: lensLogoImageView.bottomAnchor,constant: -30),
            
            buttonContainer.topAnchor.constraint(equalTo: lensLogoImageView.bottomAnchor, constant: 30),
            buttonContainer.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor)
        ])
        
        navigationItem.title = ""
        navigationItem.largeTitleDisplayMode = .inline
    }
    
    @objc func cameraTapped() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .camera
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    @objc func albumTapped() {
        PHPhotoLibrary.requestAuthorization { status in
            switch status {
            case .authorized:
                DispatchQueue.main.async {
                    self.openPhotoLibrary()
                }
            case .denied, .restricted:
                DispatchQueue.main.async {
                    self.showAccessDeniedAlert()
                }
            case .notDetermined:
                // 권한이 아직 결정되지 않은 경우
                break
            case .limited:
                DispatchQueue.main.async {
                    self.openPhotoLibrary()
                }
            @unknown default:
                fatalError("Unknown case for PHPhotoLibrary authorization status")
            }
        }
    }
    
    private func openPhotoLibrary() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    private func showAccessDeniedAlert() {
        let alert = UIAlertController(title: "권한 필요",
                                      message: "앱에서 사진 라이브러리에 접근하려면 권한이 필요합니다. 설정에서 접근 권한을 허용해주세요.",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
    
    @objc func historyTapped() {
        show(HistoryViewController(), sender: nil)
    }
}

// 사진 선택 후
extension RequestImageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let userPickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            fatalError("Failed Original Image pick")
        }
        
        guard let coreImage = CIImage(image: userPickedImage) else {
            fatalError("Failed CIImage convert")
        }
        
        visionObjectRecognitionModel.setupVision()
        visionObjectRecognitionModel.VisonHandler(image: coreImage)
        visionObjectRecognitionModel.selectedImage = userPickedImage

        picker.dismiss(animated: true) {
            let resultViewController = ResultViewController()
            resultViewController.selectedImage = userPickedImage
            self.navigationController?.pushViewController(resultViewController, animated: true)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}
