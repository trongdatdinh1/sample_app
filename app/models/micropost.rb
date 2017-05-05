class Micropost < ApplicationRecord
  belongs_to :user

  scope :ordered_by_date, ->{order created_at: :desc}
  scope :user_id_in, ->(following_ids, id){where(
    "user_id IN (:following_ids) OR user_id = :user_id",
    following_ids: following_ids, user_id: id)}
  mount_uploader :picture, PictureUploader

  validates :user, presence: true
  validates :content, presence: true, length: {maximum: 140}
  validate :picture_size

  private
  def picture_size
    if picture.size > 5.megabytes
      errors.add :picture, t("should_less_than_5mb")
    end
  end
end
