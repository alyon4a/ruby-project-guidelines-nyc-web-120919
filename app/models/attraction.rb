class Attraction < ActiveRecord::Base
    has_many :reviews
    has_many :users, through: :reviews

    has_many :attraction_likes

    def user_likes
        self.attraction_likes.map{|likes| likes.user}
    end

    def add_review(review_hash, user)
        review_hash[:user_id] = user.id
        review_hash[:attraction_id] = self.id
        Review.create(review_hash)
        user.reviews.reload
        attraction.reviews.reload
    end

end