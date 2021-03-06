class Post < ActiveRecord::Base
  PER_PAGE = 3

  include Voteable
  include Sluggable
  
  belongs_to :creator, foreign_key: 'user_id', class_name: 'User'
  has_many :comments, dependent: :destroy
  has_many :post_categories, dependent: :destroy
  has_many :categories, through: :post_categories

  validates :title, presence: true, length: {minimum: 5}
  validates :url, presence: true  
  validates :description, presence: true

  sluggable_column :title

end
