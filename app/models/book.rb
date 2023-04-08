class Book < ApplicationRecord
  belongs_to :user
  has_many :book_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy

  has_many :book_tag_relations, dependent: :destroy
  has_many :tags, through: :book_tag_relations

  validates :title,presence:true
  validates :body,presence:true,length:{maximum:200}



def save_tags(savebook_tags)
  current_tags = self.tags.pluck(:name) unless self.tags.nil?
  old_tags = current_tags - savebook_tags
  new_tags = savebook_tags - current_tags

  old_tags.each do |old_name|
    self.tags.delete Tag.find_by(name:old_name)
  end

  new_tags.each do |old_name|
    book_tag = Tag.find_or_create_by(name:new_name)
    self.tags << book_tag
  end
end


  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end


  def self.search_for(word,search)
    if search == "perfect"
      Book.where(title: word)
    elsif search == "forward"
      Book.where("title LIKE?","#{word}%")
    elsif search == "backward"
      Book.where("title LIKE?","%#{word}")
    else
      Book.where("title LIKE?","%#{word}%")
    end
  end

end
