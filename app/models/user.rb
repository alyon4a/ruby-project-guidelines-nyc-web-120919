require_relative "attractionLike"

class User < ActiveRecord::Base
    has_many :reviews
    has_many :attractions, through: :reviews

    has_many :attraction_likes
    def likes
        self.attraction_likes.map {|likes| Attraction.find(likes.attraction_id)}
    end
end