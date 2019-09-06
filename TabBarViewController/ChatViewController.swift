//
//  ChatViewController.swift
//  Tikitalka
//
//  Created by Jane Shin on 8/7/19.
//  Copyright © 2019 Jane Shin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import Kingfisher
import Alamofire
import AVFoundation
import Photos
import CropViewController
import MobileCoreServices
import AVFoundation
import CropViewController
class ChatViewController: UICollectionViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout {

    let inputTextField: UITextField! = {
        let textField = UITextField()
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        textField.font = UIFont(name: "KBIZforSMEsgo L", size: 15)
        return textField
    }()
    
    var isfromNotification = false
    var userModel: UserModel?
    var allUser: AllUserModel?
    var CurrentUser = [CurrentUserModel]()
    var Chat = [ChatModel]()
    var username: String?
    var isSearching = true
    
    var groupedMessagesByDates = [[ChatModel.dateModelStructure]]()
    var messagesFromServer = [ChatModel.dateModelStructure]()
    var sections: Int?
    var dateSection = [[ChatModel.dateModelStructure]]()
    
    var isInChatViewController = true
    
    var selectedImageFromPicker: UIImage?
    var startingFrame: CGRect?
    var backgroundView: UIView?
    var startingImageView: UIImageView?
    var blurBackground: UIVisualEffectView?

    let imageView = UIImageView()
    var croppingStyle = CropViewCroppingStyle.default
    var croppedRect = CGRect.zero
    var croppedAngle = 0
    
    var inputContainerHeight: NSLayoutConstraint?
    var inputContainerHeightX: NSLayoutConstraint?
    var textFieldAppeared = false
    
    var badges = 0
    
    var menuContents = ["menu"]
    var tableView = UITableView()
    let menuHeight: CGFloat = {
        var height = CGFloat()
        if UIDevice.modelName == "iPhone XS Max" || UIDevice.modelName == "iPhone XR" {
            height = 100
        }
        else if UIDevice.modelName == "iPhone 6 Plus" || UIDevice.modelName == "iPhone 6s Plus" || UIDevice.modelName == "Simulator iPhone 7 Plus" || UIDevice.modelName == "iPhone 8 Plus"{
            height = 100
        } else if UIDevice.modelName == "Simulator iPhone X" || UIDevice.modelName == "iPhone XS" {
            height = 100
        } else if UIDevice.modelName == "iPhone 6" || UIDevice.modelName == "iPhone 6s" || UIDevice.modelName == "Simulator iPhone 7" || UIDevice.modelName == "iPhone 8"{
            height = 70
        } else {
            height = 70
        }
        return height
    }()
    var transparentView: UIView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(chatMessageCell.self, forCellWithReuseIdentifier: "chatMessageCell")
        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerId")
        tableView.register(menuCell.self, forCellReuseIdentifier: "menuCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        inputTextField.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false

        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 0)
//        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 2, right: 0)
        collectionView.backgroundColor = .white
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .interactive
        
        inputContainerHeight = inputContainerVeiw.heightAnchor.constraint(equalToConstant: 50)
        inputContainerHeight?.isActive = false
        inputContainerHeightX = inputContainerVeiw.heightAnchor.constraint(equalToConstant: 70)
        inputContainerHeightX?.isActive = false
        
        if UIDevice.modelName == "iPhone XS Max" || UIDevice.modelName == "iPhone XS" || UIDevice.modelName == "iPhone XR" || UIDevice.modelName == "iPhone X" {
            inputContainerHeightX?.isActive = true
            inputContainerHeight?.isActive = false
        }
        else {
            inputContainerHeight?.isActive = true
            inputContainerHeightX?.isActive = false
        }
        
        setupUI()
        
    }

    
//    @objc func showChat(notification: Notification) {
//        guard let text = notification.userInfo?["uid"] as? String else { return }
//        print ("uid: \(text)")
//    }
    
    func setupUI() {
        setCurrentUserInfo()
        observeMessageLog()
        setupNavigationBar()
        badgeCount()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupKeyboardObserver()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        isInChatViewController = false
        NotificationCenter.default.removeObserver(self)
    }

    
    @objc func dismissChat() {
        self.view.endEditing(true)
        if isfromNotification {
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            let mainStoryboard = UIStoryboard(name: "MainTabBar", bundle: nil)
            let homeController =  mainStoryboard.instantiateViewController(withIdentifier: "MainTabBarID") as! UITabBarController
            appDelegate?.window?.rootViewController = homeController
            
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 80
        let groupMessage = self.groupedMessagesByDates[indexPath.section][indexPath.row]
        if let text = groupMessage.text {
            height = estimateFrameText(text: text).height + 17
        } else if let imageWidth = groupMessage.imageWidth?.floatValue, let imageHeight = groupMessage.imageHeight?.floatValue {
            height = CGFloat(imageHeight / imageWidth * 200)
        }
        let width = UIScreen.main.bounds.width
        return CGSize(width: width, height: height)
    }

    private func estimateFrameText(text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        if UIDevice.modelName == "iPhone XS Max" || UIDevice.modelName == "iPhone XR" {
            return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font : UIFont.init(name: "KBIZforSMEsgo L", size: 15)!
                ], context: nil)
        }
        else if UIDevice.modelName == "iPhone 6 Plus" || UIDevice.modelName == "iPhone 6s Plus" || UIDevice.modelName == "Simulator iPhone 7 Plus" || UIDevice.modelName == "iPhone 8 Plus"{
            return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font : UIFont.init(name: "KBIZforSMEsgo L", size: 15)!
                ], context: nil)
        } else if UIDevice.modelName == "Simulator iPhone X" || UIDevice.modelName == "iPhone XS" {
            return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font : UIFont.init(name: "KBIZforSMEsgo L", size: 14)!
                ], context: nil)
        } else if UIDevice.modelName == "iPhone 6" || UIDevice.modelName == "iPhone 6s" || UIDevice.modelName == "Simulator iPhone 7" || UIDevice.modelName == "iPhone 8"{
            return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font : UIFont.init(name: "KBIZforSMEsgo L", size: 13)!
                ], context: nil)
        } else {
            return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font : UIFont.init(name: "KBIZforSMEsgo L", size: 13)!
                ], context: nil)
        }
//        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font : UIFont.init(name: "KBIZforSMEsgo L", size: 15)!
//            ], context: nil)
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        var count = 0
        if collectionView == self.collectionView {
            count = self.groupedMessagesByDates.count
        }
        return count
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerId", for: indexPath) as! HeaderView
        let dates = self.groupedMessagesByDates[indexPath.section]
        if let firstMessage = dates.first?.date {
            header.date.text = firstMessage
        }
        return header
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: view.frame.width, height: 80)
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        sections = section
        return self.groupedMessagesByDates[section].count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "chatMessageCell", for: indexPath) as! chatMessageCell
        cell.chatViewController = self
        let groupedMessages = self.groupedMessagesByDates[indexPath.section][indexPath.row]
        cell.chat = groupedMessages
        
        cell.textView.text = groupedMessages.text
        cell.timestampLabel.text = groupedMessages.timestampString
        setupCell(cell: cell, chat: groupedMessages)
        
        cell.timestampLabel.isHidden = false
        if indexPath.row - 1 == -1 {
            cell.timestampLabel.isHidden = false

        } else {
            if groupedMessages.timestampString == self.groupedMessagesByDates[indexPath.section][indexPath.row - 1].timestampString {
                cell.timestampLabel.isHidden = true
                cell.profileImageView.isHidden = true
            }
        }
        
        if let text = groupedMessages.text {
            cell.bubbleWidthAnchor?.constant = estimateFrameText(text: text).width + 24
            cell.textView.isHidden = false
            cell.saveToCameraRollButton.isHidden = true
        } else if groupedMessages.imageUrl != nil {
            cell.bubbleWidthAnchor?.constant = 200
            cell.bubbleView.backgroundColor = .clear
            cell.textView.isHidden = true
            cell.saveToCameraRollButton.isHidden = false
        }
        
        cell.playButton.isHidden = groupedMessages.videoUrl == nil
            
        return cell
    }
    
    private func setupCell(cell: chatMessageCell, chat: ChatModel.dateModelStructure) {
        
        if let messageImageUrl = chat.imageUrl {
            let url = URL(string: messageImageUrl)
            cell.messageImageView.kf.setImage(with: url)
            cell.messageImageView.isHidden = false
            cell.bubbleView.backgroundColor = .clear
        } else {
            cell.messageImageView.isHidden = true
        }
        if chat.senderUid == Auth.auth().currentUser?.uid {
            cell.bubbleView.backgroundColor = #colorLiteral(red: 0.6617934108, green: 0, blue: 0.05319330841, alpha: 1).withAlphaComponent(0.9)
            cell.textView.textColor = .white
            cell.profileImageView.isHidden = true
            
            cell.bubbleRightAnchor?.isActive = true
            cell.bubbleLeftAnchor?.isActive = false
            
            cell.timestampLeftAnchor?.isActive = false
            cell.timestampRightAnchor?.isActive = true
            
            cell.saveButtonLeftAnchor?.isActive = false
            cell.saveButtonRightAnchor?.isActive = true
            
            cell.saveIndicatorLeftAnchor?.isActive = false
            cell.saveIndicatorRightAnchor?.isActive = true
            
        } else {
            cell.bubbleView.backgroundColor = #colorLiteral(red: 0.9411043525, green: 0.9412171841, blue: 0.9410660267, alpha: 1).withAlphaComponent(0.8)
            cell.textView.textColor = .black
            cell.profileImageView.isHidden = false

            if isSearching {
                let url = URL(string: allUser!.profileImageUrl!)
                cell.profileImageView.kf.setImage(with: url)
            } else if !isSearching {
                let url = URL(string: userModel!.profileImageUrl!)
                cell.profileImageView.kf.setImage(with: url)
            }
            
            cell.bubbleRightAnchor?.isActive = false
            cell.bubbleLeftAnchor?.isActive = true
            
            cell.timestampLeftAnchor?.isActive = true
            cell.timestampRightAnchor?.isActive = false
            
            cell.saveButtonLeftAnchor?.isActive = true
            cell.saveButtonRightAnchor?.isActive = false
            
            cell.saveIndicatorLeftAnchor?.isActive = true
            cell.saveIndicatorRightAnchor?.isActive = false
        }
    }
    
    var containerBottomConstraint: NSLayoutConstraint?
    
    lazy var inputContainerVeiw: UIView = {
        let containerView = UIView()
        let galleryButton = UIButton(type: .system)
        let sendButton = UIButton(type: .system)
        let cameraButton = UIButton(type: .system)

        containerView.addSubview(galleryButton)
        containerView.addSubview(cameraButton)
        containerView.addSubview(inputTextField)
        containerView.addSubview(sendButton)

        galleryButton.translatesAutoresizingMaskIntoConstraints = false
        cameraButton.translatesAutoresizingMaskIntoConstraints = false
        inputTextField.translatesAutoresizingMaskIntoConstraints = false
        sendButton.translatesAutoresizingMaskIntoConstraints = false

//            containerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 40)
        if UIDevice.modelName == "iPhone XS Max" || UIDevice.modelName == "iPhone XS" || UIDevice.modelName == "iPhone XR" || UIDevice.modelName == "iPhone X" {
            containerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 70)
        }
        else {
            containerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        }

        
//        containerView.backgroundColor = UIColor(white: 0.95, alpha: 0.9)
        containerView.backgroundColor = .white

        galleryButton.centerYAnchor.constraint(equalTo: inputTextField.centerYAnchor).isActive = true
        galleryButton.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 5).isActive = true
        galleryButton.widthAnchor.constraint(equalToConstant: 35).isActive = true
        galleryButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        cameraButton.centerYAnchor.constraint(equalTo: inputTextField.centerYAnchor).isActive = true
        cameraButton.leftAnchor.constraint(equalTo: galleryButton.rightAnchor, constant: -5).isActive = true
        cameraButton.widthAnchor.constraint(equalToConstant: 35).isActive = true
        cameraButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        inputTextField.placeholder = "Enter text here..."
        //        inputTextField.frame = CGRect(x: 40, y: 5, width: 310, height: 35)
        inputTextField.leftAnchor.constraint(equalTo: cameraButton.rightAnchor, constant: 5).isActive = true
        inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor, constant: 5).isActive = true
        inputTextField.heightAnchor.constraint(equalToConstant: 35).isActive = true
        inputTextField.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8).isActive = true

        sendButton.centerYAnchor.constraint(equalTo: inputTextField.centerYAnchor).isActive = true
        sendButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -5).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        sendButton.heightAnchor.constraint(equalToConstant: 35).isActive = true

        inputTextField.backgroundColor = .white
        inputTextField.layer.borderWidth = 1
        inputTextField.layer.borderColor = UIColor.lightGray.cgColor
        inputTextField.layer.cornerRadius = 18
        inputTextField.clipsToBounds = true

        let leftView = UILabel(frame: CGRect(x: 10, y: 0, width: 14, height: 35))
        let rightView = UILabel(frame: CGRect(x: -10, y: 0, width: 5, height: 35))
        inputTextField.leftView = leftView
        inputTextField.leftViewMode = .always
        inputTextField.rightView = rightView
        inputTextField.rightViewMode = .always
        galleryButton.setImage(#imageLiteral(resourceName: "gallery").withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: UIControl.State.normal)
        galleryButton.tintColor = UIColor.lightGray
        cameraButton.setImage(#imageLiteral(resourceName: "camera").withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: UIControl.State.normal)
        cameraButton.tintColor = UIColor.lightGray

        sendButton.setTitle("Send", for: UIControl.State.normal)
        sendButton.setTitleColor(#colorLiteral(red: 0, green: 0.4799541235, blue: 0.9984330535, alpha: 1), for: UIControl.State.normal)
        sendButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        sendButton.addTarget(self, action: #selector(handleSend), for: UIControl.Event.touchUpInside)

        galleryButton.isUserInteractionEnabled = true
        let galleryTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleGallery))
//        let galleryTapGesture = UITapGestureRecognizer(target: self, action: #selector(presentPicker))
        galleryButton.addGestureRecognizer(galleryTapGesture)
        
        cameraButton.isUserInteractionEnabled = true
        let cameraTapGesture = UITapGestureRecognizer(target: self, action: #selector(presentCamera))
        cameraButton.addGestureRecognizer(cameraTapGesture)
        
        let textFieldTapGesture = UITapGestureRecognizer(target: self, action: #selector(textFieldAddObserver))
        inputTextField.addGestureRecognizer(textFieldTapGesture)
        
        return containerView
    }()
    
    @objc func textFieldAddObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        inputTextField.becomeFirstResponder()
    }
    
    /*
     Control Show Menu
    */
    @objc func handleGallery() {
//        transparentView.isHidden = false
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let navHeight = navigationController?.navigationBar.frame.size.height
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        transparentView.frame = self.view.frame
        view.addSubview(transparentView)
        
        let screenSize = UIScreen.main.bounds.size
        tableView.frame = CGRect(x: 0, y: navHeight! + statusBarHeight, width: screenSize.width, height: menuHeight)
        view.addSubview(tableView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissMenu))
        transparentView.addGestureRecognizer(tapGesture)
        
        transparentView.alpha = 0
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: {
            self.transparentView.alpha = 0.5
            self.tableView.frame = CGRect(x: 0, y: navHeight! + statusBarHeight, width: screenSize.width, height: self.menuHeight)
        }, completion: nil)
    }
    
    @objc func dismissMenu() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: {
            self.transparentView.alpha = 0
            self.tableView.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        }, completion: nil)
    }

    override var inputAccessoryView: UIView? {
        get {
            return inputContainerVeiw
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
}

class chatMessageCell: UICollectionViewCell {
    
    var chat: ChatModel.dateModelStructure?
//    var chat: ChatModel?
    var chatViewController: ChatViewController?
    var playerLayer: AVPlayerLayer?
    var player: AVPlayer?
    var isMuted = false
    
    let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .whiteLarge)
        aiv.translatesAutoresizingMaskIntoConstraints = false
        aiv.hidesWhenStopped = true
        return aiv
    }()
    
    lazy var playButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "play"), for: UIControl.State.normal)
        button.tintColor = UIColor.white
        button.addTarget(self, action: #selector(handlePlay), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    @objc func handlePlay() {
        if let videoUrlString = chat?.videoUrl, let url = NSURL(string: videoUrlString ) {
            let asset = AVAsset(url: url as URL)
            let duration = asset.duration
            let durationTime = CMTimeGetSeconds(duration)
            print(durationTime,"------")
            player = AVPlayer(url: url as URL)
            playerLayer = AVPlayerLayer(player: player)
            playerLayer?.frame = bubbleView.bounds
            bubbleView.layer.addSublayer(playerLayer!)
            player?.play()
            activityIndicatorView.startAnimating()
            playButton.isHidden = true
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        playerLayer?.removeFromSuperlayer()
        player?.pause()
        activityIndicatorView.stopAnimating()
    }

    let textView: UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        if UIDevice.modelName == "iPhone XS Max" || UIDevice.modelName == "iPhone XR" {
            tv.font = UIFont(name: "KBIZforSMEsgo L", size: 15)
        }
        else if UIDevice.modelName == "iPhone 6 Plus" || UIDevice.modelName == "iPhone 6s Plus" || UIDevice.modelName == "Simulator iPhone 7 Plus" || UIDevice.modelName == "iPhone 8 Plus"{
            tv.font = UIFont(name: "KBIZforSMEsgo L", size: 15)
        } else if UIDevice.modelName == "Simulator iPhone X" || UIDevice.modelName == "iPhone XS" {
            tv.font = UIFont(name: "KBIZforSMEsgo L", size: 14)
        } else if UIDevice.modelName == "iPhone 6" || UIDevice.modelName == "iPhone 6s" || UIDevice.modelName == "Simulator iPhone 7" || UIDevice.modelName == "iPhone 8"{
            tv.font = UIFont(name: "KBIZforSMEsgo L", size: 13)
        } else {
            tv.font = UIFont(name: "KBIZforSMEsgo L", size: 13)
        }
//        tv.font = UIFont(name: "KBIZforSMEsgo L", size: 15)
        tv.backgroundColor = .clear
        tv.isEditable = false
        return tv
    }()
    
    let bubbleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        return view
    }()
    
    let profileImageView: UIImageView = {
        let profileImage = UIImageView()
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        profileImage.layer.cornerRadius = 15
        profileImage.clipsToBounds = true
        profileImage.contentMode = .scaleAspectFill
        return profileImage
    }()
    
    lazy var messageImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 15
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomTap)))
        imageView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(handleZoomPlayer)))
        return imageView
    }()
    
    @objc func handleZoomTap(tapGesture: UITapGestureRecognizer) {
        if chat?.videoUrl != nil && self.playerLayer != nil {
            isMuted = !isMuted
            player?.isMuted = isMuted
            player?.pause()
            playerLayer?.removeFromSuperlayer()
            playButton.isHidden = false
            activityIndicatorView.stopAnimating()
            return
        }
        if let imageView = tapGesture.view as? UIImageView {
            self.chatViewController?.performZoomInForStartingImageView(startingImageView: imageView)
        }
    }
    
    var startingFrame: CGRect?
    var startingImageView: UIImageView?
    var blurBackground: UIVisualEffectView?
    var zoomingView: UIView?
    
    @objc func handleZoomPlayer(longGesture: UILongPressGestureRecognizer) {
        if chat?.videoUrl != nil && self.playerLayer != nil && self.player != nil {
            longGesture.minimumPressDuration = 0.5
            if let imageView = longGesture.view as? UIImageView {
                if longGesture.state == .began {
                    self.startingImageView = imageView
                    startingFrame = startingImageView?.superview?.convert(startingImageView!.frame, to: nil)
                    zoomingView = UIView(frame: startingFrame!)
                    if let keyWindow = UIApplication.shared.keyWindow {
                        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
                        blurBackground = UIVisualEffectView(effect: blurEffect)
                        blurBackground?.frame = keyWindow.frame
                        startingImageView!.isHidden = true
                        self.playerLayer?.frame = zoomingView!.bounds
                        zoomingView!.layer.addSublayer(self.playerLayer!)
                        keyWindow.addSubview(blurBackground!)
                        keyWindow.addSubview(zoomingView!)
                        let height = startingFrame!.height / startingFrame!.width * keyWindow.frame.width
                        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                            self.blurBackground?.alpha = 1
                            self.chatViewController!.inputContainerVeiw.alpha = 0
                            self.zoomingView!.frame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: height)
                            self.playerLayer!.frame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: height)
                            self.zoomingView!.layer.cornerRadius = 15
                            self.zoomingView!.clipsToBounds = true
                            self.zoomingView!.center = keyWindow.center
                        }, completion: nil)
                    }
                } else if longGesture.state == .ended {
                    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                        self.zoomingView!.frame = self.startingFrame!
                        self.blurBackground?.alpha = 0
                        self.chatViewController!.inputContainerVeiw.alpha = 1
                        self.isMuted = !self.isMuted
                        self.player?.isMuted = self.isMuted
                        self.player?.pause()
                        self.player = nil
                    }, completion: { (completed) in
                        self.playerLayer?.removeFromSuperlayer()
                        self.playButton.isHidden = false
                        self.activityIndicatorView.stopAnimating()
                        self.zoomingView!.removeFromSuperview()
                        self.startingImageView?.isHidden = false
                    })
                }
            }
        }
    }
    
    let timestampLabel: UILabel = {
        let timestamp = UILabel()
        timestamp.translatesAutoresizingMaskIntoConstraints = false
        timestamp.font = UIFont(name: "AppleSDGothicNeo-Light", size: 11)
        timestamp.textColor = UIColor.lightGray
        timestamp.textAlignment = .right
        return timestamp
    }()
    
    let saveActivityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .gray)
        aiv.translatesAutoresizingMaskIntoConstraints = false
        aiv.hidesWhenStopped = true
        return aiv
    }()
    
    lazy var saveToCameraRollButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "save"), for: UIControl.State.normal)
        button.tintColor = .lightGray
        button.isUserInteractionEnabled = true
        button.addTarget(self, action: #selector(handleSaveToCameraRoll), for: UIControl.Event.touchDown)
        return button
    }()
    
    @objc func handleSaveToCameraRoll() {
        saveActivityIndicatorView.startAnimating()
        saveToCameraRollButton.isHidden = true
        if let videoUrl = chat?.videoUrl {
            let url = URL(string: videoUrl)
            self.downloadAndSave(videoUrl: url!, completion: { (completed: Bool) -> Void in
                if completed {
                    DispatchQueue.main.async {
                        self.saveToCameraRollButton.isHidden = false
                        self.saveActivityIndicatorView.stopAnimating()
                        let alert = UIAlertController(title: "Saved", message: "Video saved successfully", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default))
                        self.chatViewController!.present(alert, animated: true, completion: nil)
                    }
                }
            })
//            let urlData = NSData(contentsOf: url!)
//            let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0];
//            let filePath="\(documentsPath)/tempFile.mp4"
//            urlData!.write(toFile: filePath, atomically: false)
//            DispatchQueue.main.async {
//                PHPhotoLibrary.shared().performChanges({
//                    PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: URL(fileURLWithPath: filePath))
//                }) { completed, error in
//                    if completed {
//                        let alertController = UIAlertController(title: "Your video was successfully saved", message: nil, preferredStyle: .alert)
//                        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//                        alertController.addAction(defaultAction)
//                        self.chatViewController!.present(alertController, animated: true, completion: nil)
//                    }
//                }
//            }

        } else {
            let url = URL(string: chat!.imageUrl!)
            let data = try? Data(contentsOf: url!)
            
            if let imageData = data {
                let image = UIImage(data: imageData)
                UIImageWriteToSavedPhotosAlbum(image!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
            }
        }
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            chatViewController!.present(alert, animated: true)
        } else {
            self.saveToCameraRollButton.isHidden = false
            self.saveActivityIndicatorView.stopAnimating()
            let alert = UIAlertController(title: "Saved", message: "Image saved successfully", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            chatViewController!.present(alert, animated: true)
        }
    }
    
    func downloadAndSave(videoUrl: URL, completion: @escaping (Bool) -> Void) {
        let destination: (URL, HTTPURLResponse) -> (URL, DownloadRequest.DownloadOptions) = {
            tempUrl, response in

            let option = DownloadRequest.DownloadOptions()
            let finalUrl = tempUrl.deletingPathExtension().appendingPathExtension(videoUrl.pathExtension)
            return (finalUrl, option)
        }

        Alamofire.download(videoUrl, to: destination)
            .response(completionHandler: { [weak self] response in
                guard response.error == nil,
                    let destinationUrl = response.destinationURL else {
                        completion(false)
                        return
                }
                self?.save(videoFileUrl: destinationUrl, completion: completion)
            })
    }
    
    private func save(videoFileUrl: URL, completion: @escaping (Bool) -> Void) {
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: videoFileUrl)
        }, completionHandler: { succeeded, error in
            guard error == nil, succeeded else {
                completion(false)
                return
            }
            
            completion(true)
        })
    }
    
    var bubbleWidthAnchor: NSLayoutConstraint?
    var bubbleLeftAnchor: NSLayoutConstraint?
    var bubbleRightAnchor: NSLayoutConstraint?
    var timestampLeftAnchor: NSLayoutConstraint?
    var timestampRightAnchor: NSLayoutConstraint?
    var saveButtonLeftAnchor: NSLayoutConstraint?
    var saveButtonRightAnchor: NSLayoutConstraint?
    var saveIndicatorLeftAnchor: NSLayoutConstraint?
    var saveIndicatorRightAnchor: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bubbleView)
        addSubview(textView)
        addSubview(profileImageView)
        addSubview(timestampLabel)
        addSubview(saveToCameraRollButton)
        addSubview(saveActivityIndicatorView)
        
        bubbleView.addSubview(messageImageView)
        messageImageView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor).isActive = true
        messageImageView.topAnchor.constraint(equalTo: bubbleView.topAnchor).isActive = true
        messageImageView.widthAnchor.constraint(equalTo: bubbleView.widthAnchor).isActive = true
        messageImageView.heightAnchor.constraint(equalTo: bubbleView.heightAnchor).isActive = true

        bubbleView.addSubview(playButton)
        playButton.centerXAnchor.constraint(equalTo: bubbleView.centerXAnchor).isActive = true
        playButton.centerYAnchor.constraint(equalTo: bubbleView.centerYAnchor).isActive = true
        playButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        playButton.heightAnchor.constraint(equalToConstant: 50).isActive = true

        bubbleView.addSubview(activityIndicatorView)
        activityIndicatorView.centerXAnchor.constraint(equalTo: bubbleView.centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: bubbleView.centerYAnchor).isActive = true
        activityIndicatorView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        activityIndicatorView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        bubbleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        bubbleLeftAnchor = bubbleView.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8)
        bubbleLeftAnchor?.isActive = false
        bubbleRightAnchor = bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8)
        bubbleRightAnchor?.isActive = true
        bubbleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 200)
        bubbleWidthAnchor!.isActive = true
        bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
//        bubbleDateBottomAnchor = bubbleView.topAnchor.constraint(equalTo: self.topAnchor, constant: 30)
//        bubbleDateBottomAnchor?.isActive = true
//        bubbleTopAnchor = bubbleView.topAnchor.constraint(equalTo: self.topAnchor)
//        bubbleTopAnchor?.isActive = false
//        bubbleLeftAnchor = bubbleView.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8)
//        bubbleLeftAnchor?.isActive = false
//        bubbleRightAnchor = bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8)
//        bubbleRightAnchor?.isActive = true
//        bubbleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 200)
//        bubbleWidthAnchor!.isActive = true
//        bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true

        textView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 7).isActive = true
//        textView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        textView.topAnchor.constraint(equalTo: bubbleView.topAnchor).isActive = true
        textView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor).isActive = true
        textView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        timestampLabel.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: -5).isActive = true
        timestampLeftAnchor = timestampLabel.leftAnchor.constraint(equalTo: bubbleView.rightAnchor, constant: -10)
        timestampLeftAnchor?.isActive = false
        timestampRightAnchor = timestampLabel.rightAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: -5)
        timestampRightAnchor?.isActive = true
        timestampLabel.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        saveToCameraRollButton.centerYAnchor.constraint(equalTo: bubbleView.centerYAnchor).isActive = true
        saveButtonLeftAnchor = saveToCameraRollButton.leftAnchor.constraint(equalTo: bubbleView.rightAnchor, constant: 20)
        saveButtonLeftAnchor?.isActive = false
        saveButtonRightAnchor = saveToCameraRollButton.rightAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: -20)
        saveButtonRightAnchor?.isActive = true
        saveToCameraRollButton.widthAnchor.constraint(equalToConstant: 23).isActive = true
        saveToCameraRollButton.heightAnchor.constraint(equalToConstant: 23).isActive = true
        
        saveActivityIndicatorView.centerYAnchor.constraint(equalTo: bubbleView.centerYAnchor).isActive = true
        saveIndicatorLeftAnchor = saveActivityIndicatorView.leftAnchor.constraint(equalTo: bubbleView.rightAnchor, constant: 20)
        saveIndicatorLeftAnchor?.isActive = false
        saveIndicatorRightAnchor = saveActivityIndicatorView.rightAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: -20)
        saveIndicatorRightAnchor?.isActive = true
        saveActivityIndicatorView.widthAnchor.constraint(equalToConstant: 23).isActive = true
        saveActivityIndicatorView.heightAnchor.constraint(equalToConstant: 23).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class menuCell: UITableViewCell {
    var chatViewController: ChatViewController?
    var seperatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        return view
    }()
    
    lazy var photoLabelView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.isUserInteractionEnabled = true
        return view
    }()
    
    
    lazy var videoLabelView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.isUserInteractionEnabled = true
        return view
    }()
    
    var photoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Photo"
        label.textColor = .lightGray
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    var videoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Video"
        label.textColor = .lightGray
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(photoLabelView)
        addSubview(videoLabelView)
        addSubview(seperatorView)
        addSubview(photoLabel)
        addSubview(videoLabel)
        
        if UIDevice.modelName == "iPhone XS Max" || UIDevice.modelName == "iPhone XR" {
            photoLabelView.topAnchor.constraint(equalTo: topAnchor).isActive = true
            photoLabelView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
            photoLabelView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/2).isActive = true
            photoLabelView.heightAnchor.constraint(equalToConstant: 150).isActive = true
            
            videoLabelView.topAnchor.constraint(equalTo: topAnchor).isActive = true
            videoLabelView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
            videoLabelView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/2).isActive = true
            videoLabelView.heightAnchor.constraint(equalToConstant: 150).isActive = true
            
            seperatorView.widthAnchor.constraint(equalToConstant: 0.7).isActive = true
            seperatorView.heightAnchor.constraint(equalToConstant: 80).isActive = true
            seperatorView.leftAnchor.constraint(equalTo: photoLabelView.rightAnchor).isActive = true
            seperatorView.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
            
            photoLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: (((UIScreen.main.bounds.width / 2) - 45) / 2)).isActive = true
            photoLabel.topAnchor.constraint(equalTo: topAnchor, constant: 88/2).isActive = true
            photoLabel.widthAnchor.constraint(equalToConstant: 45).isActive = true
            photoLabel.heightAnchor.constraint(equalToConstant: 12).isActive = true
            
            videoLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -(((UIScreen.main.bounds.width / 2) - 45) / 2)).isActive = true
            videoLabel.topAnchor.constraint(equalTo: topAnchor, constant: 88/2).isActive = true
            videoLabel.widthAnchor.constraint(equalToConstant: 45).isActive = true
            videoLabel.heightAnchor.constraint(equalToConstant: 12).isActive = true
        }
        else if UIDevice.modelName == "iPhone 6 Plus" || UIDevice.modelName == "iPhone 6s Plus" || UIDevice.modelName == "Simulator iPhone 7 Plus" || UIDevice.modelName == "iPhone 8 Plus"{
            photoLabelView.topAnchor.constraint(equalTo: topAnchor).isActive = true
            photoLabelView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
            photoLabelView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/2).isActive = true
            photoLabelView.heightAnchor.constraint(equalToConstant: 150).isActive = true
            
            videoLabelView.topAnchor.constraint(equalTo: topAnchor).isActive = true
            videoLabelView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
            videoLabelView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/2).isActive = true
            videoLabelView.heightAnchor.constraint(equalToConstant: 150).isActive = true
            
            seperatorView.widthAnchor.constraint(equalToConstant: 0.7).isActive = true
            seperatorView.heightAnchor.constraint(equalToConstant: 80).isActive = true
            seperatorView.leftAnchor.constraint(equalTo: photoLabelView.rightAnchor).isActive = true
            seperatorView.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
            
            photoLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: (((UIScreen.main.bounds.width / 2) - 45) / 2)).isActive = true
            photoLabel.topAnchor.constraint(equalTo: topAnchor, constant: 88/2).isActive = true
            photoLabel.widthAnchor.constraint(equalToConstant: 45).isActive = true
            photoLabel.heightAnchor.constraint(equalToConstant: 12).isActive = true
            
            videoLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -(((UIScreen.main.bounds.width / 2) - 45) / 2)).isActive = true
            videoLabel.topAnchor.constraint(equalTo: topAnchor, constant: 88/2).isActive = true
            videoLabel.widthAnchor.constraint(equalToConstant: 45).isActive = true
            videoLabel.heightAnchor.constraint(equalToConstant: 12).isActive = true
        } else if UIDevice.modelName == "Simulator iPhone X" || UIDevice.modelName == "iPhone XS" {
            photoLabelView.topAnchor.constraint(equalTo: topAnchor).isActive = true
            photoLabelView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
            photoLabelView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/2).isActive = true
            photoLabelView.heightAnchor.constraint(equalToConstant: 150).isActive = true
            
            videoLabelView.topAnchor.constraint(equalTo: topAnchor).isActive = true
            videoLabelView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
            videoLabelView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/2).isActive = true
            videoLabelView.heightAnchor.constraint(equalToConstant: 150).isActive = true
            
            seperatorView.widthAnchor.constraint(equalToConstant: 0.7).isActive = true
            seperatorView.heightAnchor.constraint(equalToConstant: 80).isActive = true
            seperatorView.leftAnchor.constraint(equalTo: photoLabelView.rightAnchor).isActive = true
            seperatorView.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
            
            photoLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: (((UIScreen.main.bounds.width / 2) - 45) / 2)).isActive = true
            photoLabel.topAnchor.constraint(equalTo: topAnchor, constant: 88/2).isActive = true
            photoLabel.widthAnchor.constraint(equalToConstant: 45).isActive = true
            photoLabel.heightAnchor.constraint(equalToConstant: 12).isActive = true
            
            videoLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -(((UIScreen.main.bounds.width / 2) - 45) / 2)).isActive = true
            videoLabel.topAnchor.constraint(equalTo: topAnchor, constant: 88/2).isActive = true
            videoLabel.widthAnchor.constraint(equalToConstant: 45).isActive = true
            videoLabel.heightAnchor.constraint(equalToConstant: 12).isActive = true
        } else if UIDevice.modelName == "iPhone 6" || UIDevice.modelName == "iPhone 6s" || UIDevice.modelName == "Simulator iPhone 7" || UIDevice.modelName == "iPhone 8"{
            photoLabelView.topAnchor.constraint(equalTo: topAnchor).isActive = true
            photoLabelView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
            photoLabelView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/2).isActive = true
            photoLabelView.heightAnchor.constraint(equalToConstant: 70).isActive = true
            
            videoLabelView.topAnchor.constraint(equalTo: topAnchor).isActive = true
            videoLabelView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
            videoLabelView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/2).isActive = true
            videoLabelView.heightAnchor.constraint(equalToConstant: 70).isActive = true
            
            seperatorView.widthAnchor.constraint(equalToConstant: 0.7).isActive = true
            seperatorView.heightAnchor.constraint(equalToConstant: 50).isActive = true
            seperatorView.leftAnchor.constraint(equalTo: photoLabelView.rightAnchor).isActive = true
            seperatorView.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
            
            photoLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: (((UIScreen.main.bounds.width / 2) - 45) / 2)).isActive = true
            photoLabel.topAnchor.constraint(equalTo: topAnchor, constant: 70/2 - 6).isActive = true
            photoLabel.widthAnchor.constraint(equalToConstant: 45).isActive = true
            photoLabel.heightAnchor.constraint(equalToConstant: 12).isActive = true
            
            videoLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -(((UIScreen.main.bounds.width / 2) - 45) / 2)).isActive = true
            videoLabel.topAnchor.constraint(equalTo: topAnchor, constant: 70/2 - 6).isActive = true
            videoLabel.widthAnchor.constraint(equalToConstant: 45).isActive = true
            videoLabel.heightAnchor.constraint(equalToConstant: 12).isActive = true
        } else {
            photoLabelView.topAnchor.constraint(equalTo: topAnchor).isActive = true
            photoLabelView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
            photoLabelView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/2).isActive = true
            photoLabelView.heightAnchor.constraint(equalToConstant: 70).isActive = true
            
            videoLabelView.topAnchor.constraint(equalTo: topAnchor).isActive = true
            videoLabelView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
            videoLabelView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/2).isActive = true
            videoLabelView.heightAnchor.constraint(equalToConstant: 70).isActive = true
            
            seperatorView.widthAnchor.constraint(equalToConstant: 0.7).isActive = true
            seperatorView.heightAnchor.constraint(equalToConstant: 50).isActive = true
            seperatorView.leftAnchor.constraint(equalTo: photoLabelView.rightAnchor).isActive = true
            seperatorView.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
            
            photoLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: (((UIScreen.main.bounds.width / 2) - 45) / 2)).isActive = true
            photoLabel.topAnchor.constraint(equalTo: topAnchor, constant: 70/2 - 6).isActive = true
            photoLabel.widthAnchor.constraint(equalToConstant: 45).isActive = true
            photoLabel.heightAnchor.constraint(equalToConstant: 12).isActive = true
            
            videoLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -(((UIScreen.main.bounds.width / 2) - 45) / 2)).isActive = true
            videoLabel.topAnchor.constraint(equalTo: topAnchor, constant: 70/2 - 6).isActive = true
            videoLabel.widthAnchor.constraint(equalToConstant: 45).isActive = true
            videoLabel.heightAnchor.constraint(equalToConstant: 12).isActive = true
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath) as! menuCell
        didTapPhotoGallery(cell: cell)
        didTapVideoGallery(cell: cell)
        cell.selectionStyle = .none
        return cell
    }
    
    func didTapPhotoGallery(cell: menuCell) {
        cell.photoLabelView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(photoPresentPicker)))
    }
    
    func didTapVideoGallery(cell: menuCell) {
        cell.videoLabelView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(videoPresentPicker)))
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIDevice.modelName == "iPhone XS Max" || UIDevice.modelName == "iPhone XR" {
            return 100
        }
        else if UIDevice.modelName == "iPhone 6 Plus" || UIDevice.modelName == "iPhone 6s Plus" || UIDevice.modelName == "Simulator iPhone 7 Plus" || UIDevice.modelName == "iPhone 8 Plus"{
            return 100
        } else if UIDevice.modelName == "Simulator iPhone X" || UIDevice.modelName == "iPhone XS" {
            return 100
        } else if UIDevice.modelName == "iPhone 6" || UIDevice.modelName == "iPhone 6s" || UIDevice.modelName == "Simulator iPhone 7" || UIDevice.modelName == "iPhone 8"{
            return 70
        } else {
            return 70
        }
    }
    
    
}
