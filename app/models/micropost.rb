class Micropost < ApplicationRecord
  belongs_to :user

  default_scope -> { order("created_at DESC") }

  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validate  :picture_size

  mount_uploader :picture, PictureUploader

  private

    def picture_size
      return unless picture.size > 5.megabytes

      errors.add(:picture, "should be less than 5 Mb.")
    end
end
