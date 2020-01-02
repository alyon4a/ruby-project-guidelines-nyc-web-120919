class Attraction < ActiveRecord::Base
    has_many :reviews
    has_many :users, through: :reviews

    has_many :attraction_likes
    def user_likes
        AttractionLike.where("attraction_id=?", self.id)
    end
end