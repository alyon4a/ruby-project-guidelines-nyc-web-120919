require_relative 'wish_list_item'
require_relative "attractionLike"

class User < ActiveRecord::Base
    has_many :reviews
    has_many :attractions, through: :reviews
    has_many :attraction_likes
    has_many :wish_list_items
    
    def wish_list
        wish_list_items.map{|wl_item| wl_item.attraction}
    end

    def add_to_wish_list(attraction)
        WishListItem.create(user_id: self.id, attraction_id: attraction.id)
        self.reload
    end

    def delete_from_wish_list(wl_item)
        WishListItem.delete(wl_item.id)
        self.wish_list_items.reload
    end

    def likes
        self.attraction_likes.map {|likes| likes.attraction}
    end
end

