class Item

  include DataMapper::Resource

  property :id, Serial
  property :name, String
  property :taggable, Boolean, :default => false
  belongs_to :user

end
