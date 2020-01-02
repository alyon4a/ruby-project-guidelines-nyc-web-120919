require_relative "attractionLike"

class User < ActiveRecord::Base
    has_many :reviews
    has_many :attractions, through: :reviews

    has_many :attraction_likes
    def likes
        AttractionLike.where("user_id=?", self.id)
    end
end