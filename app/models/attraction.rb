class Attraction < ActiveRecord::Base
    has_many :reviews
    has_many :users, through: :reviews

    has_many :attraction_likes
    def user_likes
        self.attraction_likes.map{|likes| User.find(likes.user_id)}
    end
end