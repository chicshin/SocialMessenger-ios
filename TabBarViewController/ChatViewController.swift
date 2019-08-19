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
import AVFoundation

class ChatViewController: UICollectionViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout {

    let inputTextField: UITextField! = UITextField()
    
    var userModel: UserModel?
    var destination = [CurrentUserModel]()
    var Chat = [ChatModel]()
    
    var groupedMessagesByDates = [[ChatModel.dateModelStructure]]()
    var messagesFromServer = [ChatModel.dateModelStructure]()
    var sections: Int?
    var dateSection = [[ChatModel.dateModelStructure]]()
    
    var selectedImageFromPicker: UIImage?
    var startingFrame: CGRect?
    var backgroundView: UIView?
    var startingImageView: UIImageView?
    var blurBackground: UIVisualEffectView?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(chatMessageCell.self, forCellWithReuseIdentifier: "chatMessageCell")
        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerId")
        collectionView.delegate = self
        collectionView.dataSource = self
        inputTextField.delegate = self
        
        collectionView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 10, right: 0)
//        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 2, right: 0)
        collectionView.backgroundColor = .white
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .interactive
        setupUI()
    }
    
    func setupUI() {
        observeMessageLog()
        setupNavigationBar()
        setupKeyboardObserver()
    }

    @objc func dismissChat() {
        self.view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 80
        let groupMessage = self.groupedMessagesByDates[indexPath.section][indexPath.row]
        if let text = groupMessage.text {
            height = estimateFrameText(text: text).height + 20
        } else if let imageWidth = groupMessage.imageWidth?.floatValue, let imageHeight = groupMessage.imageHeight?.floatValue {
            height = CGFloat(imageHeight / imageWidth * 200)
        }
        let width = UIScreen.main.bounds.width
        return CGSize(width: width, height: height)
    }

    private func estimateFrameText(text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)], context: nil)
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.groupedMessagesByDates.count
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
        cell.textView.text = groupedMessages.text

        cell.timestampLabel.text = groupedMessages.timestampString
        cell.timestampLabel.isHidden = false
        if indexPath.row - 1 == -1 {
            cell.timestampLabel.isHidden = false
        } else {
            if groupedMessages.timestampString == self.groupedMessagesByDates[indexPath.section][indexPath.row - 1].timestampString {
                cell.timestampLabel.isHidden = true
            }
        }


        cell.chat = groupedMessages
        cell.textView.text = groupedMessages.text
        setupCell(cell: cell, chat: groupedMessages)
        if let text = groupedMessages.text {
            cell.bubbleWidthAnchor?.constant = estimateFrameText(text: text).width + 24
            cell.textView.isHidden = false
        } else if groupedMessages.imageUrl != nil {
            cell.bubbleWidthAnchor?.constant = 200
            cell.bubbleView.backgroundColor = .clear
            cell.textView.isHidden = true
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
            
        } else {
            cell.bubbleView.backgroundColor = #colorLiteral(red: 0.9411043525, green: 0.9412171841, blue: 0.9410660267, alpha: 1).withAlphaComponent(0.8)
            cell.textView.textColor = .black
            cell.profileImageView.isHidden = false
            let url = URL(string: userModel!.profileImageUrl!)
            cell.profileImageView.kf.setImage(with: url)
            
            cell.bubbleRightAnchor?.isActive = false
            cell.bubbleLeftAnchor?.isActive = true
            
            cell.timestampLeftAnchor?.isActive = true
            cell.timestampRightAnchor?.isActive = false
        }
    }
    
    lazy var inputContainerVeiw: UIView = {
        let containerView = UIView()
        let additionalButton = UIButton()
        let sendButton = UIButton(type: .system)

        containerView.addSubview(inputTextField)
        containerView.addSubview(additionalButton)
        containerView.addSubview(sendButton)

        additionalButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        inputTextField.translatesAutoresizingMaskIntoConstraints = false

        containerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 60)
        containerView.backgroundColor = UIColor(white: 0.95, alpha: 0.9)

        inputTextField.placeholder = "Enter text here..."
//        inputTextField.frame = CGRect(x: 40, y: 5, width: 310, height: 35)
        inputTextField.leftAnchor.constraint(equalTo: additionalButton.rightAnchor, constant: 5).isActive = true
        inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor, constant: 5).isActive = true
        inputTextField.heightAnchor.constraint(equalToConstant: 35).isActive = true
        inputTextField.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8).isActive = true

        additionalButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 5).isActive = true
        additionalButton.widthAnchor.constraint(equalToConstant: 35).isActive = true
        additionalButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        additionalButton.centerYAnchor.constraint(equalTo: inputTextField.centerYAnchor).isActive = true

        sendButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -5).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        sendButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: inputTextField.centerYAnchor).isActive = true

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
        additionalButton.setImage(#imageLiteral(resourceName: "add_circle").withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: UIControl.State.normal)
        additionalButton.tintColor = UIColor.lightGray

        sendButton.setTitle("Send", for: UIControl.State.normal)
        sendButton.setTitleColor(#colorLiteral(red: 0, green: 0.4799541235, blue: 0.9984330535, alpha: 1), for: UIControl.State.normal)
        sendButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        sendButton.addTarget(self, action: #selector(handleSend), for: UIControl.Event.touchUpInside)

        additionalButton.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(presentPicker))
        additionalButton.addGestureRecognizer(tapGesture)
        
        return containerView
    }()
    
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
        tv.font = UIFont.systemFont(ofSize: 16)
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
        return imageView
    }()
    
    let timestampLabel: UILabel = {
        let timestamp = UILabel()
        timestamp.translatesAutoresizingMaskIntoConstraints = false
        timestamp.font = UIFont.systemFont(ofSize: 12)
        timestamp.textColor = UIColor.lightGray
        return timestamp
    }()
    
//    let dateLabel: UILabel = {
//        let date = UILabel()
//        date.translatesAutoresizingMaskIntoConstraints = false
//        date.font = UIFont.systemFont(ofSize: 12)
//        date.textColor = UIColor.lightGray
//        date.backgroundColor = .yellow
//        return date
//    }()
    
    @objc func handleZoomTap(tapGesture: UITapGestureRecognizer) {
        if chat?.videoUrl != nil {
            return
        }
        if let imageView = tapGesture.view as? UIImageView {
            self.chatViewController?.performZoomInForStartingImageView(startingImageView: imageView)
        }
    }
    
    var bubbleWidthAnchor: NSLayoutConstraint?
    var bubbleLeftAnchor: NSLayoutConstraint?
    var bubbleRightAnchor: NSLayoutConstraint?
    var timestampLeftAnchor: NSLayoutConstraint?
    var timestampRightAnchor: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bubbleView)
        addSubview(textView)
        addSubview(profileImageView)
        addSubview(timestampLabel)
        
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

        textView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 8).isActive = true
//        textView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        textView.topAnchor.constraint(equalTo: bubbleView.topAnchor).isActive = true
        textView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor).isActive = true
        textView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        timestampLabel.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: -5).isActive = true
        timestampLeftAnchor = timestampLabel.leftAnchor.constraint(equalTo: bubbleView.rightAnchor, constant: 5)
        timestampLeftAnchor?.isActive = false
        timestampRightAnchor = timestampLabel.rightAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: -5)
        timestampRightAnchor?.isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
