class User < ApplicationRecord
  before_save { self.email = email.downcase } # save前に小文字変換

  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i # 正規表現
  validates :email, length: { maximum: 100 }, format: { with: VALID_EMAIL_REGEX }, # 存在性の検証は不要
                    uniqueness: true # 一意性検証
  has_secure_password # passwordﾊｯｼｭ化など
  validates :password, presence: true, length: { minimum: 6 }
end
