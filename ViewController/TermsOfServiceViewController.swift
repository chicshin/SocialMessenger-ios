//
//  TermsOfServiceViewController.swift
//  Tikitalka
//
//  Created by Jane Shin on 9/9/19.
//  Copyright © 2019 Jane Shin. All rights reserved.
//

import UIKit

class TermsOfServiceViewController: UIViewController {

    var textView: UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.text = "Terms and conditions\nThese terms and conditions are an agreement between TikiTalka Developer and you. This Agreement sets forth the general terms and conditions of your use of the TikiTalka mobile application and any of its products or services.\nBasic terms\n(a) You must be at least 17 years. (b) You may not post nude, partially nude, or sexually suggestive photos.  (c) You are responsible for any activity that occurs under your screen name. (d) You are responsible for keeping your password secure. (e) You must not abuse, harass, threaten, impersonate or intimidate other Instagram users. (f)You must not modify, adapt or hack Tiki Talka or modify another website so as to falsely imply that it is associated with Tiki Talka. Violation of any of these agreements will result in the termination of your account. \nAccounts and membership\nYou must be at least 17 years of age to use this Mobile Application. By using this TikiTalka Application and by agreeing to this Agreement you warrant and represent that you are at least 17 years of age. If you create an account in the Mobile Application, you are responsible for maintaining the security of your account and you are fully responsible for all activities that occur under the account and any other actions taken in connection with it. We may monitor and review new accounts before you may sign in and use our Services. Providing false contact information of any kind may result in the termination of your account. You must immediately notify us of any unauthorized uses of your account or any other breaches of security. We will not be liable for any acts or omissions by you, including any damages of any kind incurred as a result of such acts or omissions. We may suspend, disable, or delete your account (or any part thereof) if we determine that you have violated any provision of this Agreement or that your conduct or content would tend to damage our reputation and goodwill. If we delete your account for the foregoing reasons, you may not re-register for our Services. We may block your email address and Internet protocol address to prevent further registration.\nUser content\nWe do not own any data, information or material that you submit in the Mobile Application in the course of using the Service. You shall have sole responsibility for the accuracy, quality, integrity, legality, reliability, appropriateness, and intellectual property ownership or right to use of all submitted Content. We may, but have no obligation to, monitor and review Content in the Mobile Application submitted or created using our Services by you. Unless specifically permitted by you, your use of the Mobile Application does not grant us the license to use, reproduce, adapt, modify, publish or distribute the Content created by you or stored in your user account for commercial, marketing or any similar purpose. But you grant us permission to access, copy, distribute, store, transmit, reformat, display and perform the Content of your user account solely as required for the purpose of providing the Services to you.\nBackups\nWe perform regular backups of the Content and will do our best to ensure completeness and accuracy of these backups. In the event of the hardware failure or data loss we will restore backups automatically to minimize the impact and downtime.\nLinks to other mobile applications\nAlthough this Mobile Application may link to other mobile applications, we are not, directly or indirectly, implying any approval, association, sponsorship, endorsement, or affiliation with any linked mobile application, unless specifically stated herein. We are not responsible for examining or evaluating, and we do not warrant the offerings of, any businesses or individuals or the content of their mobile applications. We do not assume any responsibility or liability for the actions, products, services, and content of any other third-parties. You should carefully review the legal statements and other conditions of use of any mobile application which you access through a link from this Mobile Application. Your linking to any other off-site mobile applications is at your own risk.\nProhibited uses\nIn addition to other terms as set forth in the Agreement, you are prohibited from using the Mobile Application or its Content: (a) for any unlawful purpose; (b) to solicit others to perform or participate in any unlawful acts; (c) to violate any international, federal, provincial or state regulations, rules, laws, or local ordinances; (d) to infringe upon or violate our intellectual property rights or the intellectual property rights of others; (e) to harass, abuse, insult, harm, defame, slander, disparage, intimidate, or discriminate based on gender, sexual orientation, religion, ethnicity, race, age, national origin, or disability; (f) to submit false or misleading information; (g) to upload or transmit viruses or any other type of malicious code that will or may be used in any way that will affect the functionality or operation of the Service or of any related mobile application, other mobile applications, or the Internet; (h) to collect or track the personal information of others; (i) to spam, phish, pharm, pretext, spider, crawl, or scrape; (j) for any obscene or immoral purpose; or (k) to interfere with or circumvent the security features of the Service or any related mobile application, other mobile applications, or the Internet. We reserve the right to terminate your use of the Service or any related mobile application for violating any of the prohibited uses.\nIntellectual property rights\nThis Agreement does not transfer to you any intellectual property owned by Mobile Application Developer or third-parties, and all rights, titles, and interests in and to such property will remain (as between the parties) solely with Mobile Application Developer. All trademarks, service marks, graphics and logos used in connection with our Mobile Application or Services, are trademarks or registered trademarks of Mobile Application Developer or Mobile Application Developer licensors. Other trademarks, service marks, graphics and logos used in connection with our Mobile Application or Services may be the trademarks of other third-parties. Your use of our Mobile Application and Services grants you no right or license to reproduce or otherwise use any Mobile Application Developer or third-party trademarks.\nLimitation of liability\nTo the fullest extent permitted by applicable law, in no event will Mobile Application Developer, its affiliates, officers, directors, employees, agents, suppliers or licensors be liable to any person for (a): any indirect, incidental, special, punitive, cover or consequential damages (including, without limitation, damages for lost profits, revenue, sales, goodwill, use of content, impact on business, business interruption, loss of anticipated savings, loss of business opportunity) however caused, under any theory of liability, including, without limitation, contract, tort, warranty, breach of statutory duty, negligence or otherwise, even if Mobile Application Developer has been advised as to the possibility of such damages or could have foreseen such damages. To the maximum extent permitted by applicable law, the aggregate liability of Mobile Application Developer and its affiliates, officers, employees, agents, suppliers and licensors, relating to the services will be limited to an amount greater of one dollar or any amounts actually paid in cash by you to Mobile Application Developer for the prior one month period prior to the first event or occurrence giving rise to such liability. The limitations and exclusions also apply if this remedy does not fully compensate you for any losses or fails of its essential purpose.\nChanges and amendments\nWe reserve the right to modify this Agreement or its policies relating to the Mobile Application or Services at any time, effective upon posting of an updated version of this Agreement in the Mobile Application. When we do, we will revise the updated date at the bottom of this page. Continued use of the Mobile Application after any such changes shall constitute your consent to such changes. Policy was created with WebsitePolicies.\nAcceptance of these terms\nYou acknowledge that you have read this Agreement and agree to all its terms and conditions. By using the Mobile Application or its Services you agree to be bound by this Agreement. If you do not agree to abide by the terms of this Agreement, you are not authorized to use or access the Mobile Application and its Services.\nContacting us\nIf you would like to contact us to understand more about this Agreement or wish to contact us concerning any matter relating to it, you may send an email to inchicshin@gmail.com\nThis document was last updated on September 1, 2019"
        return tv
    }()
    
    var dismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Back", for: UIControl.State.normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(dismissButton)
        view.addSubview(textView)
        setUI()
        didTapDismiss()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppDelegate.AppUtility.lockOrientation(.portrait)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.all)
    }
    
    func didTapDismiss() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissChat))
        dismissButton.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissChat() {
        dismiss(animated: true, completion: nil)
    }
    
    func setUI() {
        dismissButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 30).isActive = true
        dismissButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        dismissButton.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        dismissButton.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        
        textView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        textView.topAnchor.constraint(equalTo: dismissButton.bottomAnchor).isActive = true
        textView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        textView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height - 40).isActive = true
    }

}
