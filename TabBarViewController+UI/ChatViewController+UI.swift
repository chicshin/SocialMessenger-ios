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
import Alamofire
import MobileCoreServices
import AVFoundation
import CropViewController

extension ChatViewController {
    func setupNavigationBar() {
        if isSearching {
            navigationItem.title = self.allUser!.username!
        } else if !isSearching {
            navigationItem.title = self.userModel!.username!
        }
        let dismissButton = UIBarButtonItem(image: #imageLiteral(resourceName: "back_icon"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(dismissChat))
        navigationItem.leftBarButtonItem = dismissButton
    }
    
    
    
    
    /*
        Control Badge Count
    */
    func badgeCount() {
        var chatPartnerUid: String?
        if isSearching {
            chatPartnerUid = allUser!.uid!
        } else if !isSearching {
            chatPartnerUid = userModel!.uid!
        }
        Ref().databaseRoot.child("user-messages").child(chatPartnerUid!).observe(.childAdded, with: { (snapshot) in
            let toUid = snapshot.key
            Ref().databaseRoot.child("user-messages").child(chatPartnerUid!).child(toUid).observe(.childAdded, with: { (dataSanpshot) in
                let messageId = dataSanpshot.key
                Ref().databaseRoot.child("messages").child(messageId).observe(.value, with: { (messageSnapshot) in
                    if let dict = messageSnapshot.value as? [String:Any] {
                        let read = dict["read"] as! Int
                        let toId = dict["toUid"] as! String
                        if toId == chatPartnerUid {
                            if read == 1 {
                                self.badges += 1
                            }
                        }
                    }
                })
            })
        })

    }
    
    
    
    
    
    /*
        Control Message Log
    */
    func observeMessageLog() {
        let uid = Auth.auth().currentUser?.uid
        var totalMessagesCount: Int?
        var toUid: String?
        if isSearching {
            toUid = allUser!.uid!
        } else if !isSearching {
            toUid = userModel!.uid!
        }
        
        Ref().databaseRoot.child("user-messages").child(uid!).child(toUid!).observe(.value, with: { (snapshot) in
            totalMessagesCount = Int(snapshot.childrenCount)
        })
        var dataStructure = [ChatModel.dateModelStructure]()
        var retrievedMessagesFromServer = self.messagesFromServer
        Ref().databaseRoot.child("user-messages").child(uid!).child(toUid!).observe(.childAdded, with: { (snapshot) in
            let messageId = snapshot.key
            self.groupedMessagesByDates.removeAll()
            Ref().databaseRoot.child("messages").child(messageId).observeSingleEvent(of: .value, with: { (data) in
                guard let dictionary = data.value as? [String:Any] else {
                    return
                }

                let chat = ChatModel(dictionary: dictionary)
                self.Chat.append(chat)
                
                if chat.senderUid != uid && self.isInChatViewController == true {
                    Ref().databaseRoot.child("messages").child(messageId).updateChildValues(["read": 0])
                }
                
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
                    
                    var today: String?
                    let timestamp: NSNumber = NSNumber(value: Int(NSDate().timeIntervalSince1970))
                    let timestampDate = NSDate(timeIntervalSince1970: TimeInterval(truncating: timestamp))
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    today = dateFormatter.string(from: timestampDate as Date)
//
                    if key != today {
                        values = values?.sorted(by: { (lhs: ChatModel.dateModelStructure, rhs: ChatModel.dateModelStructure) in
                            let lhsValue = lhs.timestamp as! Int
                            let rhsValue = rhs.timestamp as! Int
                            return lhsValue < rhsValue
                        })
                    }
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
    
    func setCurrentUserInfo() {
        let uid = Auth.auth().currentUser?.uid
        
        Ref().databaseUsers.child(uid!).observe(.value, with: { (snapshot) in
            self.CurrentUser.removeAll()
            if let dict = snapshot.value as? [String:Any] {
                let user = CurrentUserModel()
                user.setValuesForKeys(dict)
                self.CurrentUser.append(user)
            }
        })
    }
    
    
    
    
    
    
    /*
        Control Observer
    */
    func setupKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    
    @objc func handleKeyboardWillShow() {
        inputContainerVeiw.translatesAutoresizingMaskIntoConstraints = false
        inputContainerHeight?.isActive = true
        inputContainerHeightX?.isActive = false
        
        if groupedMessagesByDates.count > 0 {
            let section = (self.collectionView?.numberOfSections)! - 1
            let indexPath = NSIndexPath(item: groupedMessagesByDates[section].count - 1, section: section)
            self.collectionView.scrollToItem(at: indexPath as IndexPath, at: UICollectionView.ScrollPosition.top, animated: true)
        }
    }
    
    @objc func handleKeyboardWillHide() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        if UIDevices.modelName == "iPhone XS Max" || UIDevices.modelName == "iPhone XS" || UIDevices.modelName == "iPhone XR" || UIDevices.modelName == "iPhone X" {
            inputContainerVeiw.translatesAutoresizingMaskIntoConstraints = false
            inputContainerHeightX?.isActive = true
            inputContainerHeight?.isActive = false
        }
        else {
            inputContainerVeiw.translatesAutoresizingMaskIntoConstraints = false
            inputContainerHeight?.isActive = true
            inputContainerHeightX?.isActive = false
        }
    }
    
    
    
    
    /*
        Control FCM
    */
    func setFcm(payloadDict: [String:Any]) {
        let url = "https://fcm.googleapis.com/fcm/send"
        
        let NSUrl = NSURL(string: url)!
        let request = NSMutableURLRequest(url: NSUrl as URL)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: payloadDict, options: [])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("key=AIzaSyDA3sKFVIMUl_t5ADdEkKOW-iCo26DIgjw", forHTTPHeaderField: "Authorization")
        
        let task =  URLSession.shared.dataTask(with: request as URLRequest)  { (data, response, error) in
            do {
                if let jsonData = data {
                    if let jsonDataDict  = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: AnyObject] {
                        NSLog("Received data:\n\(jsonDataDict))")
                    }
                }
            } catch let err as NSError {
                print(err.debugDescription)
            }
        }
        task.resume()
        
    }
    
    func sendFcm(videoUrl: String?) {
        let name = Auth.auth().currentUser?.displayName
        
        let notificationModel = NotificationModel()
        if isSearching {
            notificationModel.to = allUser?.pushToken
            if allUser?.notifications!["showPreview"] as! String == "enabled" {
                if inputTextField.text != "" {
                    notificationModel.notification.text = inputTextField.text
                } else if videoUrl != nil {
                    notificationModel.notification.text = "Sent a video"
                } else {
                    notificationModel.notification.text = "Sent an image"
                }
            } else {
                notificationModel.notification.text = "Sent a new message"
            }
            
        } else if !isSearching {
            notificationModel.to = userModel?.pushToken
            if userModel?.notifications!["showPreview"] as! String == "enabled" {
                if inputTextField.text != "" {
                    notificationModel.notification.text = inputTextField.text
                } else if videoUrl != nil {
                    notificationModel.notification.text = "Sent a video"
                } else {
                    notificationModel.notification.text = "Sent an image"
                }
            } else {
                notificationModel.notification.text = "Sent a new message"
            }
        }
        notificationModel.notification.title = name
        notificationModel.data.title = name
        notificationModel.data.text = inputTextField.text
        
        guard let token = notificationModel.to else {
            return
        }
        let showPreviewContent = CurrentUser[0].notifications!["showPreview"]
        let payload: [String: Any] = ["to": token, "notification": ["body": name!.lowercased() + " : " + notificationModel.notification.text!, "badge": self.badges + 1, "sound": "default"], "data" : ["uid": CurrentUser[0].uid!, "email": CurrentUser[0].email!, "fullname": CurrentUser[0].fullname!, "username": CurrentUser[0].username!, "profileImageUrl": CurrentUser[0].profileImageUrl!, "pushToken": CurrentUser[0].pushToken!, "showPreview": showPreviewContent!]]
        self.setFcm(payloadDict: payload)
    }
    
    
    
    
    
    /*
        Control imagePicker
    */
    @objc func videoPresentPicker() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.mediaTypes = [kUTTypeMovie as String]
        picker.allowsEditing = true
        picker.videoMaximumDuration = 60
        self.present(picker, animated: true, completion: nil)
    }
    
    @objc func photoPresentPicker() {
        self.croppingStyle = .default
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = false
        self.present(picker, animated: true, completion: nil)
    }
    
    @objc func presentCamera() {
        self.croppingStyle = .default
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .camera
        picker.allowsEditing = false
        self.present(picker, animated: true, completion: nil)
    }

    
    
    
    
    /*
        Control Storage
    */
    private func imageStorage(image: UIImage?, completion: @escaping(_ imageUrl: String) -> (), onSuccess: @escaping() -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
        guard let imageData = image?.jpegData(compressionQuality: 1) else {
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
//        uploadTask.observe(.progress, handler: { (snapshot) in
//            if let completedUnitCount = snapshot.progress?.completedUnitCount {
//                let data = NSData(contentsOf: videoUrl! as URL)
//                let progressPercentage = Double(completedUnitCount)/Double(data!.length) * 100
//                self.navigationItem.title = String(format: "%.0f", progressPercentage) + "%"
//            }
//        })
//        uploadTask.observe(.success, handler: { (snapshot) in
//            if self.isSearching {
//                self.navigationItem.title = self.allUser!.username!
//            } else if !self.isSearching {
//                self.navigationItem.title = self.userModel!.username!
//            }
//        })
    }
    
    
    
    
    
    
    /*
        Control Video Thumbnail
    */
    private func thumbnailImageForFileUrl(fileUrl: NSURL) -> UIImage? {
        let asset = AVAsset(url: fileUrl as URL)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        
        do {
            let thumbnailCGImage = try imageGenerator.copyCGImage(at: CMTimeMakeWithSeconds(1, preferredTimescale: 60), actualTime: nil)
            return UIImage(cgImage: thumbnailCGImage)
        } catch let err {
            print(err)
        }
        
        return nil
    }
    
    
    
    
    
    /*
        Control Send Messages
    */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSend()
        return true
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
        var toUid: String?
        var token: String?
        
        if isSearching {
            token = allUser?.pushToken
            toUid = allUser?.uid
        } else if !isSearching {
            token = userModel?.pushToken
            toUid = userModel?.uid
        }
        let timestamp: NSNumber = NSNumber(value: Int(NSDate().timeIntervalSince1970))
        
        var values : Dictionary<String,Any> = [
            "senderUid": uid!,
            "toUid": toUid!,
            "timestamp": timestamp,
            "read": 1
        ]
        properties.forEach({(values[$0] = $1)})
        if token != nil {
            sendFcm(videoUrl: properties["videoUrl"] as? String)
        }
        inputTextField.text = nil
        DatabaseService.updateMessagesWithValues(toUid: toUid!, uid: uid!, values: values)
    }
    
    
    
    
    
    /*
        Control Zoom In / Zoom Out
    */
    func performZoomInForStartingImageView(startingImageView: UIImageView) {
        self.startingImageView = startingImageView
        startingFrame = startingImageView.superview?.convert(startingImageView.frame, to: nil)
        let zoomingImageView = UIImageView(frame: startingFrame!)
        zoomingImageView.image = startingImageView.image
        zoomingImageView.isUserInteractionEnabled = true
        zoomingImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomOut)))
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomOut)))
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

extension ChatViewController: CropViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    internal func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let videoUrl = info[UIImagePickerController.InfoKey.mediaURL] as? NSURL {
            let data = NSData(contentsOf: videoUrl as URL)!
            print("File size before compression: \(Double(data.length / 1048576)) mb")
            let compressedURL = NSURL.fileURL(withPath: NSTemporaryDirectory() + NSUUID().uuidString + ".m4v")
            self.compressVideo(inputURL: videoUrl as URL, outputURL: compressedURL) { (exportSession) in
                guard let session = exportSession else {
                    return
                }
                switch session.status {
                case .unknown:
                    break
                case .waiting:
                    break
                case .exporting:
                    break
                case .completed:
                    guard let compressedData = NSData(contentsOf: compressedURL) else {
                        return
                    }
                    print("File size after compression: \(Double(compressedData.length / 1048576)) mb")
                case .failed:
                    break
                case .cancelled:
                    break
                @unknown default:
                    break
                }
            }
        } else {
//            guard let image = (info[UIImagePickerController.InfoKey.originalImage] as? UIImage) else { return }
            let image = (info[UIImagePickerController.InfoKey.originalImage] as? UIImage)
            let cropController = CropViewController(croppingStyle: croppingStyle, image: image!)
            cropController.delegate = self
            imageView.image = image
            
            picker.dismiss(animated: true, completion: {
                self.present(cropController, animated: true, completion: nil)
                if self.inputTextField.isFirstResponder == true {
                    self.handleKeyboardWillShow()
                }
                
            })
        }
        transparentView.alpha = 0
        self.tableView.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        dismiss(animated: true, completion: {
            if self.inputTextField.isFirstResponder == true {
                self.handleKeyboardWillShow()
            }
        })
    }
    
    public func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        self.croppedRect = cropRect
        self.croppedAngle = angle
        updateImageViewWithImage(image, fromCropViewController: cropViewController)
    }
    
    public func updateImageViewWithImage(_ image: UIImage, fromCropViewController cropViewController: CropViewController) {
        self.selectedImageFromPicker = image
        layoutImageView()
        if let selectedImage = selectedImageFromPicker {
            imageStorage(image: selectedImage, completion: { (imageUrl) in
                self.sendMessageWithImage(imageUrl: imageUrl, image: selectedImage)
            },onSuccess: {
                //update database and storage with image
            }) {(errorMessage) in
                ProgressHUD.showError(errorMessage)
            }
        }
        
        self.navigationItem.rightBarButtonItem?.isEnabled = true
        
        if cropViewController.croppingStyle != .circular {
            imageView.isHidden = true
            
            cropViewController.dismissAnimatedFrom(self, withCroppedImage: image,
                                                   toView: imageView,
                                                   toFrame: CGRect.zero,
                                                   setup: { self.layoutImageView() },
                                                   completion: { self.imageView.isHidden = false })
        }
        else {
            self.imageView.isHidden = false
            cropViewController.dismiss(animated: true, completion: nil)
        }
    }
    
    public func layoutImageView() {
        guard imageView.image != nil else { return }
        
        let padding: CGFloat = 20.0
        
        var viewFrame = self.view.bounds
        viewFrame.size.width -= (padding * 2.0)
        viewFrame.size.height -= ((padding * 2.0))
        
        var imageFrame = CGRect.zero
        imageFrame.size = imageView.image!.size;
        
        if imageView.image!.size.width > viewFrame.size.width || imageView.image!.size.height > viewFrame.size.height {
            let scale = min(viewFrame.size.width / imageFrame.size.width, viewFrame.size.height / imageFrame.size.height)
            imageFrame.size.width *= scale
            imageFrame.size.height *= scale
            imageFrame.origin.x = (self.view.bounds.size.width - imageFrame.size.width) * 0.5
            imageFrame.origin.y = (self.view.bounds.size.height - imageFrame.size.height) * 0.5
            imageView.frame = imageFrame
        }
        else {
            self.imageView.frame = imageFrame;
            self.imageView.center = CGPoint(x: self.view.bounds.midX, y: self.view.bounds.midY)
        }
    }
    
    @objc public func sharePhoto() {
        guard let image = imageView.image else {
            return
        }
        
        let activityController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        activityController.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem!
        present(activityController, animated: true, completion: nil)
    }

}

extension ChatViewController {
    
    func compressVideo(inputURL: URL, outputURL: URL, handler:@escaping (_ exportSession: AVAssetExportSession?)-> Void) {
        let urlAsset = AVURLAsset(url: inputURL, options: nil)
        guard let exportSession = AVAssetExportSession(asset: urlAsset, presetName: AVAssetExportPresetHighestQuality) else {
            handler(nil)
            return
        }
        
        exportSession.outputURL = outputURL
        exportSession.outputFileType = AVFileType.mov
        exportSession.shouldOptimizeForNetworkUse = true
        exportSession.exportAsynchronously { () -> Void in
            self.videoStorage(videoUrl: exportSession.outputURL as NSURL?)
            handler(exportSession)
        }
    }
}
