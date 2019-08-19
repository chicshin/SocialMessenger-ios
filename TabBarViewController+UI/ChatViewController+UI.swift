//
//  ChatViewController+UI.swift
//  Tikitalka
//
//  Created by Jane Shin on 8/7/19.
//  Copyright © 2019 Jane Shin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
import ProgressHUD
import MobileCoreServices
import AVFoundation

extension ChatViewController {
    
    func observeMessageLog() {
        let uid = Auth.auth().currentUser?.uid
        var totalMessagesCount: Int?
        Ref().databaseRoot.child("user-messages").child(uid!).child(userModel!.uid!).observe(.value, with: { (snapshot) in
            totalMessagesCount = Int(snapshot.childrenCount)
        })
        var dataStructure = [ChatModel.dateModelStructure]()
        var retrievedMessagesFromServer = self.messagesFromServer
        Ref().databaseRoot.child("user-messages").child(uid!).child(userModel!.uid!).observe(.childAdded, with: { (snapshot) in
            let messageId = snapshot.key
            self.groupedMessagesByDates.removeAll()
            Ref().databaseRoot.child("messages").child(messageId).observeSingleEvent(of: .value, with: { (data) in
                guard let dictionary = data.value as? [String:Any] else {
                    return
                }
                let chat = ChatModel(dictionary: dictionary)
                self.Chat.append(chat)
                
                func timestampString() -> String? {
                    var timeString: String?
                    if let seconds = chat.timestamp?.doubleValue {
                        let timestampDate = NSDate(timeIntervalSince1970: seconds)
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "hh:mm a"
                        timeString = dateFormatter.string(from: timestampDate as Date)
                    }
                    return timeString
                }
                
                let contentType = chat.text != nil ? "text" : chat.videoUrl != nil ? "videoUrl" : "imageUrl"
                //                    dataStructure.append(["date": date!, "content": returnValue as! String, "timestamp": timestamp!])
                //                    dataStructure.append(dateModelStructure(date: date!, content: returnValue as! String, timestamp: timestamp!))
                if contentType == "text" {
                    dataStructure.append(ChatModel.dateModelStructure(date: chat.datestampString()!, content: contentType, timestamp: chat.timestamp!, text: chat.text!, imageUrl: nil, imageWidth: nil, imageHeight: nil, videoUrl: nil, timestampString: timestampString()!, toUid: chat.toUid!, senderUid: chat.senderUid!))
                } else if contentType == "videoUrl" {
                    dataStructure.append(ChatModel.dateModelStructure(date: chat.datestampString()!, content: contentType, timestamp: chat.timestamp!, text: nil, imageUrl: chat.imageUrl!, imageWidth: chat.imageWidth!, imageHeight: chat.imageHeight!, videoUrl: chat.videoUrl!, timestampString: timestampString()!, toUid: chat.toUid!, senderUid: chat.senderUid!))
                } else if contentType == "imageUrl" {
                    dataStructure.append(ChatModel.dateModelStructure(date: chat.datestampString()!, content: contentType, timestamp: chat.timestamp!, text: nil, imageUrl: chat.imageUrl!, imageWidth: chat.imageWidth!, imageHeight: chat.imageHeight!, videoUrl: nil, timestampString: timestampString()!, toUid: chat.toUid!, senderUid: chat.senderUid!))
                }
                
                if dataStructure.count != totalMessagesCount {
                    return
                } else if dataStructure.count == totalMessagesCount  {
                    retrievedMessagesFromServer = dataStructure
                }
                
                self.messagesFromServer = retrievedMessagesFromServer

                let groupedMessages = Dictionary(grouping: self.messagesFromServer, by: { (element: ChatModel.dateModelStructure) in
                    return element.date
                })
                
                let sortedKeys = groupedMessages.keys.sorted()
                sortedKeys.forEach( { (key) in
                    var values = groupedMessages[key]
                    values = values?.sorted(by: { (lhs: ChatModel.dateModelStructure, rhs: ChatModel.dateModelStructure) in
                        let lhsValue = lhs.timestamp as! Int
                        let rhsValue = rhs.timestamp as! Int
                        return lhsValue < rhsValue
                    })
                    self.groupedMessagesByDates.append(values ?? [])
                })
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    let section = (self.collectionView?.numberOfSections)! - 1
                    let lastItemIndex = IndexPath(item: self.groupedMessagesByDates[section].count - 1, section: section)
                    self.collectionView?.scrollToItem(at: lastItemIndex, at: UICollectionView.ScrollPosition.bottom, animated: true)
                }
            })
        })
    }
    
    func setupKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
//            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func handleKeyboardDidShow() {
        if groupedMessagesByDates.count > 0 {
            let section = (self.collectionView?.numberOfSections)! - 1
            let indexPath = NSIndexPath(item: groupedMessagesByDates[section].count - 1, section: section)
            self.collectionView.scrollToItem(at: indexPath as IndexPath, at: UICollectionView.ScrollPosition.top, animated: true)
        }
    }

    func setupNavigationBar() {
        navigationItem.title = self.userModel!.username!
        let dismissButton = UIBarButtonItem(image: #imageLiteral(resourceName: "back_icon"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(dismissChat))
        navigationItem.leftBarButtonItem = dismissButton
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSend()
        return true
    }
    @objc func presentPicker() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.mediaTypes = [kUTTypeImage as String, kUTTypeMovie as String]
        self.present(picker, animated: true, completion: nil)
    }

    private func imageStorage(image: UIImage?, completion: @escaping(_ imageUrl: String) -> (), onSuccess: @escaping() -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
        guard let imageData = image?.jpegData(compressionQuality: 0.2) else {
            return
        }

        let imageName = NSUUID().uuidString
        let storageRef = Ref().storageRef.child("message_images").child(imageName)
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
    
        storageRef.putData(imageData, metadata: metadata, completion: { (metadata, error) in
            if error != nil {
                onError(error!.localizedDescription)
                return
            }
            storageRef.downloadURL(completion: { (url, error) in
                if let metaImageUrl = url?.absoluteString {
                    completion(metaImageUrl)
//                    self.sendMessageWithImage(imageUrl: metaImageUrl, image: image!)
                    onSuccess()
                }
            })
        })
    }
    
    private func videoStorage(videoUrl: NSURL?) {
        let fileName = NSUUID().uuidString + ".mov"
        let videoStorageRef = Ref().storageRef.child("message_movies").child(fileName)
        videoStorageRef.putFile(from: videoUrl! as URL, metadata: nil) { (metadata, error) in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            videoStorageRef.downloadURL(completion: { (url, error) in
                if let storageUrl = url?.absoluteString {
                    if let thumbnailImage = self.thumbnailImageForFileUrl(fileUrl: videoUrl!) {
                        self.imageStorage(image: thumbnailImage, completion: { (imageUrl) in
                            let properties: [String:Any] = ["videoUrl": storageUrl,
                                                            "imageWidth": thumbnailImage.size.width,
                                                            "imageHeight": thumbnailImage.size.height,
                                                            "imageUrl": imageUrl
                                                           ]
                            self.sendMessageWithProperties(properties: properties)
                        }, onSuccess: {
                            //
                        }, onError: { (errorMessage) in
                            ProgressHUD.showError(errorMessage)
                        })
                    }
                }
            })
        }
    }
    
    private func thumbnailImageForFileUrl(fileUrl: NSURL) -> UIImage? {
        let asset = AVAsset(url: fileUrl as URL)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        
        do {
            let thumbnailCGImage = try imageGenerator.copyCGImage(at: CMTimeMakeWithSeconds(1, preferredTimescale: 60), actualTime: nil)
            return UIImage(cgImage: thumbnailCGImage)
        } catch let err {
            print(err)
        }
        
        return nil
    }
    
    @objc func handleSend() {
        guard let text = inputTextField.text, !text.isEmpty else {
            return
        }
        let properties : Dictionary<String,Any> = [
            "text": text,
        ]
        sendMessageWithProperties(properties: properties)
    }

    private func sendMessageWithImage(imageUrl: String, image: UIImage) {
        let properties : Dictionary<String,Any> = [
            "imageUrl": imageUrl,
            "imageWidth": image.size.width,
            "imageHeight": image.size.height
        ]
        sendMessageWithProperties(properties: properties)
    }
    
    private func sendMessageWithProperties(properties: [String:Any]) {
        let uid = Auth.auth().currentUser?.uid
        let toUid = userModel!.uid
        let timestamp: NSNumber = NSNumber(value: Int(NSDate().timeIntervalSince1970))
        var values : Dictionary<String,Any> = [
            "senderUid": uid!,
            "toUid": toUid!,
            "timestamp": timestamp,
        ]
        properties.forEach({(values[$0] = $1)})
        inputTextField.text = nil
        DatabaseService.updateMessagesWithValues(toUid: toUid!, uid: uid!, values: values)
    }
    
    func performZoomInForStartingImageView(startingImageView: UIImageView) {
        self.startingImageView = startingImageView
        startingFrame = startingImageView.superview?.convert(startingImageView.frame, to: nil)
        let zoomingImageView = UIImageView(frame: startingFrame!)
        zoomingImageView.image = startingImageView.image
        zoomingImageView.isUserInteractionEnabled = true
        zoomingImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomOut)))
        if let keyWindow = UIApplication.shared.keyWindow {
            let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
            blurBackground = UIVisualEffectView(effect: blurEffect)
            blurBackground?.frame = keyWindow.frame
            startingImageView.isHidden = true
            keyWindow.addSubview(blurBackground!)
            keyWindow.addSubview(zoomingImageView)
            let height = startingFrame!.height / startingFrame!.width * keyWindow.frame.width
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blurBackground?.alpha = 1
                self.inputContainerVeiw.alpha = 0
                zoomingImageView.frame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: height)
                zoomingImageView.center = keyWindow.center
            }, completion: nil)
        }
    }
    
    @objc func handleZoomOut(tapGesture: UITapGestureRecognizer) {
        if let zoomOutImageView = tapGesture.view {
            zoomOutImageView.layer.cornerRadius = 15
            zoomOutImageView.clipsToBounds = true
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                zoomOutImageView.frame = self.startingFrame!
                self.blurBackground?.alpha = 0
                self.inputContainerVeiw.alpha = 1
            }, completion: { (completed) in
                zoomOutImageView.removeFromSuperview()
                self.startingImageView?.isHidden = false
            })
        
        }
    }
}

extension ChatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let videoUrl = info[UIImagePickerController.InfoKey.mediaURL] as? NSURL{
            videoStorage(videoUrl: videoUrl)
        } else {
            if let editedImage = info[.editedImage] as? UIImage {
                selectedImageFromPicker = editedImage
            } else if let originalImage = info[.originalImage] as? UIImage {
                selectedImageFromPicker = originalImage
            }
            
            if let selectedImage = selectedImageFromPicker {
                imageStorage(image: selectedImage, completion: { (imageUrl) in
                    self.sendMessageWithImage(imageUrl: imageUrl, image: selectedImage)
                },onSuccess: {
                    //update database and storage with image
                }) {(errorMessage) in
                    ProgressHUD.showError(errorMessage)
                }
            }
        }
        dismiss(animated: true, completion: nil)
    }
}
