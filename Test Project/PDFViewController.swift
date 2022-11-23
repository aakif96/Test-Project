//
//  PDFViewController.swift
//  Test Project
//
//  Created by Alen Akif on 17.11.22..
//

import Foundation
import UIKit
import PDFKit

class PDFViewController: UIViewController {
    
    
    
    override func viewDidLoad() {
        let pdfView = PDFView()
        
        pdfView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pdfView)
        pdfView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        pdfView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        pdfView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        pdfView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        guard let path = Bundle.main.url(forResource: "Alen Akif resume", withExtension: "pdf") else { return }
        
        if let document = PDFDocument(url: path) {
            pdfView.document = document
            pdfView.autoScales = true
            // pdfView.maxScaleFactor = 4.0
            // pdfView.minScaleFactor = pdfView.scaleFactorForSizeToFit            }
            
        }
    }
   
}
