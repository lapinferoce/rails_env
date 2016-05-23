class Post < ActiveRecord::Base
  validates :attachment,presence: true

  has_attached_file :attachment, styles: { :medium => "640x" }
  validates_attachment_content_type :attachment, :content_type => /\Aimage\/.*\Z/
end
