//
//  Viper_DemoApp.swift
//  Viper-Demo
//
//  Created by Antonijo Bezmalinovic 2025-10-14.
//

import SwiftUI
import Kingfisher

struct ShowDetailsView: View {

    // MARK: - Public properties -

    @StateObject var presenter: ShowDetailsPresenter
    
    var body: some View {
       
        ScrollView {
            VStack(alignment: .leading, spacing: 0, ) {
                if let show = presenter.show {
                    ShowHeaderView(show: show)
                    
                    if let reviews = presenter.reviews {
                        ShowReviewsView(reviews: reviews)
                    }
                    AddRatingButtonView() {
                        print("AddRatingButtonView pressed!!!")
                    }
                    .padding(.vertical, 30)
                }
            }
        }
        .overlay {
            if presenter.showProgressHUD {
                LoadingOverlayView()
            }
        }
        .padding(.horizontal, 16)
    }
}

struct AddRatingButtonView: View {
    
    let tap: () -> Void
    
    var body: some View {
        Button(action: { tap() }) {
            Text("Write a review")
                .font(.system(size: 18, weight: .medium, design: .default))
                .foregroundColor(Color.white)
        }
        .frame(maxWidth: .infinity, idealHeight: 50)
        .background(Color(red: 82.0/255.0, green: 54.0/255.0, blue: 140.0/255.0))
        .cornerRadius(25)

    }
}

struct ShowHeaderView: View {
    
    let show: Show
    
    var body: some View {
        VStack(spacing: 0) {
            ShowImageView(imageUrl: show.imageUrl, frame: nil)
            Text(show.description ?? "")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 20)
        }
    }
}

struct ShowReviewsView: View {
    
    let reviews: [Review]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Reviews")
                .font(.system(size: 25, weight: .bold, design: .default))
                .padding(.vertical, 20)
                
            OverallReviewView(reviews: reviews)
                .padding(.bottom, 20)
            VStack(spacing: 0) {
                ForEach(reviews) { review in
                    ShowReviewView(review: review)
                        .padding(.bottom, 10)
                }
            }
        }
    }
    
    struct OverallReviewView: View {

        let reviews: [Review]

        var body: some View {
            VStack(alignment: .leading, spacing:0) {
                Text("\(getNumberOfReviews()) REVIEWS, \(String(format: "%.1f", getOverallRating())) AVERAGE")
                    .font(.system(size: 14, weight: .medium, design: .default))
                    .padding(.bottom, 10)
                RatingView(rating: Int(getOverallRating()))
            }
        }
        
        func getOverallRating() -> Double {
            return Double(reviews.reduce(0) { $0 + $1.rating }) / Double(getNumberOfReviews())
        }
        
        func getNumberOfReviews() -> Int {
            return reviews.count
        }
    }
    
    struct ShowReviewView: View {
        
        let review: Review
        
        var body: some View {
            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: 0) {
                    ShowImageView(
                        imageUrl: review.user.imageUrl,
                        frame: CGSize(width: 50, height: 50),
                        placeholder: "profile_placeholder"
                    )
                        .padding(.trailing, 10)
                    VStack(alignment: .leading, spacing: 0) {
                        Text(review.user.email)
                            .font(.system(size: 12, weight: .regular))
                            .foregroundColor(Color(uiColor: UIColor.lightGray))
                        RatingView(rating: review.rating)
                            .padding(.top, 10)
                    }
                }
                Text(review.comment)
                    .padding(.vertical, 10)
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(Color(uiColor: UIColor.lightGray))
            }
        }
    }
}

struct RatingView: View {
    
    let rating: Int
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(1..<6) {
                 Image($0 <= rating ? "star_selected" : "star_unselected")
                    .frame(width: 20, height: 20)
            }
        }
    }
}

private struct ShowImageView: View {
    
    let imageUrl: String?
    let frame: CGSize?
    var placeholder = "show_placeholder"
    
    var body: some View {
        KFImage(URL(string: imageUrl ?? ""))
            .placeholder {
                Image(placeholder)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
            .resizable()
            .aspectRatio(1, contentMode: .fit)
            .clipShape(RoundedRectangle(cornerRadius: frame != nil ? frame!.width / 2 : 8))
            .frame(width: frame?.width, height: frame?.height)
    }
}
