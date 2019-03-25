//
//  DebugViewController.swift
//  SwiftyBeaverTest
//
//  Created by Andrey on 21/03/2019.
//  Copyright © 2019 anddrrek. All rights reserved.
//

import UIKit
import MessageUI

final class DebugViewController: UIViewController {
    //MARK: Constants
    private enum SendLogErrors: Error {
        case cantFindLog
        case cantReadLog
        case cantSendEmail
        
        var localizedDescription: String {
            switch self {
            case .cantFindLog:
                return "Can't find log file"
            case .cantReadLog:
                return "Can't read log file"
            case .cantSendEmail:
                return "Can't send email"
            }
        }
    }
    
    private enum Sizes: CGFloat {
        case toolbarHeight = 50
        case textViewTopInset = 20
    }
    
    //MARK: - Properties
    private let dataProvider: LogDataProvider!

    //MARK: Views
    private var toolBar: UIToolbar = {
        let bar = UIToolbar(frame: .zero)
        bar.translatesAutoresizingMaskIntoConstraints = false
        return bar
    }()
    
    private var textView: UITextView = {
        let view = UITextView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isEditable = false
        view.isSelectable = false
        return view
    }()
    
    private var sendButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Send log",
                                     style: .plain,
                                     target: self,
                                     action: #selector(sendLog))
        return button
    }()
    
    private var closeButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Close",
                                     style: .plain,
                                     target: self,
                                     action: #selector(close))
        return button
    }()
    
    private var clearLogButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Clear",
                                     style: .plain,
                                     target: self,
                                     action: #selector(clearLog))
        return button
    }()
    
    //MARK: - Initalization
    init(logProvider: LogDataProvider) {
        self.dataProvider = logProvider
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.dataProvider = nil
        super.init(coder: aDecoder)
    }
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        guard let logData = dataProvider.getLogData(),
            let text = String(data: logData, encoding: .ascii) else {
                showError(SendLogErrors.cantFindLog)
                return
        }
        textView.text = text
    }
    
    //MARK: Setup views
    private func setupViews() {
        view.addSubview(toolBar)
        view.addSubview(textView)
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                            target: nil,
                                            action: nil)
        toolBar.items = [closeButton,
                         clearLogButton,
                         flexibleSpace,
                         sendButton]
    
        NSLayoutConstraint.activate([
            toolBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            toolBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            toolBar.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            toolBar.heightAnchor.constraint(equalToConstant: Sizes.toolbarHeight.rawValue)
        ])
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.topAnchor, constant: Sizes.textViewTopInset.rawValue),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            textView.bottomAnchor.constraint(equalTo: toolBar.topAnchor, constant: 0)
            ])
    }
    
    private func showError(_ error: Error) {
        let alert = UIAlertController(title: "Error",
                                      message: error.localizedDescription,
                                      preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .destructive,
                                         handler: { [weak self] _ in
            self?.dismiss(animated: true, completion: nil)
        })
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: Actions
    @objc private func clearLog() {
        textView.text = ""
        dataProvider.clearLogFile()
    }
    
    @objc private func close() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func sendLog() {
        guard let logData = dataProvider.getLogData() else {
            showError(SendLogErrors.cantFindLog)
            return
        }
        guard MFMailComposeViewController.canSendMail() else {
            showError(SendLogErrors.cantSendEmail)
            return
        }
        let composer = MFMailComposeViewController()
        composer.mailComposeDelegate = self
        composer.delegate = self
        composer.setMessageBody("Please see attached", isHTML: false)
        composer.addAttachmentData(logData,
                                   mimeType: "text/plain",
                                   fileName: "application.log")
        
        present(composer, animated: true, completion: nil)
    }
}

//MARK: UINavigationControllerDelegate
extension DebugViewController: UINavigationControllerDelegate {}

//MARK: MFMailComposeViewControllerDelegate
extension DebugViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult,
                               error: Error?) {
        if let sendError = error {
            showError(sendError)
        } else {
            controller.dismiss(animated: true, completion: nil)
            dismiss(animated: true, completion: nil)
        }
    }
}
