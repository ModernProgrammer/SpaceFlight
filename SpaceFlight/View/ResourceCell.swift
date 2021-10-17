//
//  ResourceCell.swift
//  SpaceFlight
//
//  Created by Diego Bustamante on 10/17/21.
//

import UIKit
import SwiftUI

struct ResourceCellRowView: View {
    @ObservedObject var resourceCellRowViewModel : ResourceCellRowViewModel
    var body: some View {
        ZStack {
            HStack {
                Image(systemName: resourceCellRowViewModel.resource.image)
                Text(resourceCellRowViewModel.resource.title)
                Spacer()
            }
        }
    }
}

class ResourceCell: UITableViewCell {
    var resourceCellRowViewModel = ResourceCellRowViewModel()
    lazy var row =  ResourceCellRowView(resourceCellRowViewModel: resourceCellRowViewModel)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let hostingController = UIHostingController(rootView: row)
        hostingController.view.backgroundColor = .clear
        addSubview(hostingController.view)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: bottomAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            hostingController.view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

