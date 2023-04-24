//
//  ViewController.swift
//  SystemViewControllers
//
//  Created by Krishna Alex on 4/22/23.
//

import UIKit
import SafariServices
import MessageUI

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate {
    

    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    
    @IBAction func shareButtonTapped(_ sender: UIButton) {
        print("shareButtonTapped")
        guard let image = imageView.image else { return }
        let activityController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        activityController.popoverPresentationController?.sourceView = sender
        present(activityController, animated: true, completion: nil)
    }
    
    @IBAction func safariButtonTapped(_ sender: UIButton) {
        print("safariButtonTapped")
        if let url = URL(string: "https://apple.com") {
            let safariViewController = SFSafariViewController(url: url)
            present(safariViewController, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func emailButtonTapped(_ sender: UIButton) {
        
        print("emailButtonTapped")
        //determine whether the device has available mail services.
        guard MFMailComposeViewController.canSendMail() else {
            print("Cannot send mail")
            return
        }
        
        //Create an instance of MFMailComposeViewController and set the view controller as the mailComposeDelegate
        let mailComposer = MFMailComposeViewController()
        mailComposer.mailComposeDelegate = self
        
       // mailComposer.setToRecipients(["example@example.com"])
        mailComposer.setSubject("See attached photo")
        mailComposer.setMessageBody("Have a look at the image", isHTML: false)
        
        if let image = imageView.image, let jpegData =
            image.jpegData(compressionQuality: 0.9) {
            mailComposer.addAttachmentData(jpegData, mimeType:
                                            "image/jpeg", fileName: "photo.jpg")
        }
        //present mail composer
        present(mailComposer, animated: true, completion: nil)
        
        
    }
    
    // Dismiss the mail compose view controller and return to app
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cameraButtonTapped(_ sender: UIButton) {
        
        print("Camera button tapped")
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        let alertController = UIAlertController(title: "Choose image source", message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(cancelAction)

        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            
            let cameraAction = UIAlertAction(title: "Camera", style: .default) { action in
                imagePicker.sourceType = .camera
                self.present(imagePicker, animated: true)
            }
            alertController.addAction(cameraAction)
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            
            let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { action in
                imagePicker.sourceType = .photoLibrary
                self.present(imagePicker, animated: true)
            }
            alertController.addAction(photoLibraryAction)
        }
        
        //alertController.addAction(cameraAction)
        //alertController.addAction(photoLibraryAction)
        alertController.popoverPresentationController?.sourceView = sender
    
        present(alertController,animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info : [UIImagePickerController.InfoKey: Any]) {
        print("inside imagePickerController")
        guard let selectedImage = info[.originalImage] as? UIImage else { return }
        imageView.image = selectedImage
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func messageButtonTapped(_ sender: UIButton) {
        
        print("Messsage button tapped")
        
        if !MFMessageComposeViewController.canSendText() {
            print("SMS services are not available")
            return
        }
        
        let composeMessage = MFMessageComposeViewController()
        composeMessage.messageComposeDelegate = self
        
        //composeMessage.recipients = [""]
        composeMessage.body = "Hello from my app"
        
        self.present(composeMessage, animated: true)
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
    
}

