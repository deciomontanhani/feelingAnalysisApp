//
//  TweetCell.swift
//  FeelingAnalysisApp
//
//  Created by Decio Montanhani on 21/08/20.
//  Copyright © 2020 Decio Montanhani. All rights reserved.
//

import UIKit

final class TweetCell: UITableViewCell {

    private let userLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }()

    private let tweetLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14)
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        buildViewCode()
    }

    func setup(username: String?, tweet: String?) {
        userLabel.text = username
        tweetLabel.text = tweet
    }

    required init?(coder: NSCoder) {
        return nil
    }
}

extension TweetCell: ViewCode {
    func buildHierarchy() {
        contentView.addSubview(userLabel)
        contentView.addSubview(tweetLabel)
    }

    func buildConstraints() {
        userLabel.edges(to: self.contentView, excluding: .bottom, insets: .build(value: 20))
        tweetLabel.topToBottom(of: userLabel, offset: 8)
        tweetLabel.horizontal(of: self.contentView, offset: 20)
        tweetLabel.bottom(to: self.contentView, offset: 20)
    }

    func additionalSetup() {
        backgroundColor = .white
    }
}
