class Movie < ActiveRecord::Base
  scope :with_ratings, ->ratings { 
    where('upper(rating) IN (?)', ratings.keys.map{ |r| r.upcase }) unless ratings.blank? 
  }
  
  def self.all_ratings
    Movie.uniq.order(:rating).pluck(:rating)
  end
end
