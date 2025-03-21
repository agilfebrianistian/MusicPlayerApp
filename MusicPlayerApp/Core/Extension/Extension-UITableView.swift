//
//  Extension-UITableView.swift
//  AgilBoilerplate
//
//  Created by Agil Febrianistian on 21/03/25.
//

import Foundation
import UIKit

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell> (for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.reusableIdentifier(), for: indexPath) as? T else {
            fatalError("Can't not cast Cell with reusable identfier\(T.reusableIdentifier())")
        }
        return cell
    }

    func dequeueReusableHeaderFooterView<T: UIView> () -> T {
        guard let cell = dequeueReusableHeaderFooterView(withIdentifier:T.reusableIdentifier()) as? T else {
            fatalError("Can't not cast View with reusable identfier\(T.reusableIdentifier())")
        }
        return cell
    }

    func registerNib<T: UITableViewCell>(forCell: T.Type) {
        register(UINib(nibName: T.nibName(), bundle: nil), forCellReuseIdentifier: T.reusableIdentifier())
    }

    func registerNib<T: UIView>(forHeaderFooterView: T.Type) {
        register(UINib(nibName: T.nibName(), bundle: nil), forHeaderFooterViewReuseIdentifier: T.reusableIdentifier())
    }
}

extension UIView {
    static func nibName() -> String {
        return String(describing: self)
    }

    static func reusableIdentifier() -> String {
        return String(describing: self)
    }
}

extension UITableView {
    func setEmptyView(title: String, message: String) {
        let emptyView = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))
        let titleLabel = UILabel()
        let messageLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = UIColor.black
        titleLabel.font = .systemFont(ofSize: 18)
        messageLabel.textColor = UIColor.lightGray
        messageLabel.font = .systemFont(ofSize: 16)
        emptyView.addSubview(titleLabel)
        emptyView.addSubview(messageLabel)
        titleLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: emptyView.topAnchor, constant: 20).isActive = true
        messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        messageLabel.leftAnchor.constraint(equalTo: emptyView.leftAnchor, constant: 20).isActive = true
        messageLabel.rightAnchor.constraint(equalTo: emptyView.rightAnchor, constant: -20).isActive = true
        titleLabel.text = title
        messageLabel.text = message
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        // The only tricky part is here:
        self.backgroundView = emptyView
        self.separatorStyle = .none
    }
    
    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}
