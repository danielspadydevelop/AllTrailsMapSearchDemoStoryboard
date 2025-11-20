//
//  ResturauntTableCellView.swift
//  AllTrailsMapSearchDemoStoryboard
//
//  Created by Daniel Spady on 11/19/25.
//

import UIKit

class ResturauntTableCellView: UITableViewCell {
    
    @IBOutlet weak var resturauntLogoImageView: UIImageView!
    @IBOutlet weak var resturauntNameLabel: UILabel!
    @IBOutlet weak var starImageView: UIImageView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var reviewsLabel: UILabel!
    @IBOutlet weak var supportingLabel: UILabel!
    @IBOutlet weak var bookmarkButton: UIButton!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundColor = .clear
        
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 8
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 24, left: 16, bottom: 24, right: 16))
    }
    
    func updateCell(with viewModel: ResturauntListViewCellModel) {
        resturauntLogoImageView.image = UIImage(resource: viewModel.cellIconPlaceholder)
        resturauntNameLabel.text = viewModel.cellHeader
        starImageView.image = UIImage(resource: viewModel.cellRatingIcon)
        ratingLabel.text = "\(viewModel.cellRating)"
        reviewsLabel.text = viewModel.cellReviews
        supportingLabel.text = viewModel.cellSupporting
        bookmarkButton.imageView?.image = UIImage(resource: viewModel.cellBookmarkName)
    }
}
