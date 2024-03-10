class User < ApplicationRecord
  has_secure_password # passwordﾊｯｼｭ化など
  before_update { self.email = email.downcase } # update前に小文字変換
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i # 正規表現

  with_options on: :step1 do
    validates :name, presence: true, length: { maximum: 50 }
    validates :password, presence: true, length: { minimum: 6 }
  end

  with_options on: :step2 do
  validates :email, presence: true,length: { maximum: 100 }, format: { with: VALID_EMAIL_REGEX }, # 存在性の検証は不要
                    uniqueness: true # 一意性検証
  end
end

# emailは登録時点では必須ではないためvalidatesを2つに分け、create,updateでそれぞれ機能するようにした