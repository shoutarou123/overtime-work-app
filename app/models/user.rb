class User < ApplicationRecord
  attr_accessor :remember_token # 「remember_token」という仮想の属性を作成します。
  
  validates :name, presence: true, length: { maximum: 50 }
  
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i # 正規表現
  validates :email, length: { maximum: 100 }, format: { with: VALID_EMAIL_REGEX }, # 存在性の検証は不要
  uniqueness: true, allow_blank: true # uniqueness 一意性検証
  has_secure_password # passwordﾊｯｼｭ化など
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
  validates :employee_number, presence: true, on: :update
  validates :department, length: { in: 2..15 }, allow_blank: true
  validates :base_pay, presence: true, on: :update

   # 渡された文字列のハッシュ値を返します。
  def User.digest(string)
    cost =
      if ActiveModel::SecurePassword.min_cost
        BCrypt::Engine::MIN_COST
      else
        BCrypt::Engine.cost
      end
    BCrypt::Password.create(string, cost: cost)
  end

  # ランダムなトークンを返します。
  def User.new_token
    SecureRandom.urlsafe_base64
  end

   # 永続セッションのためハッシュ化したトークンをデータベースに記憶します。
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # トークンがダイジェストと一致すればtrueを返します。
  def authenticated?(remember_token)
    # ダイジェストが存在しない場合はfalseを返して終了します。
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def forget  # ユーザーのログイン情報を破棄します。
    update_attribute(:remember_digest, nil)
  end
end

# emailは登録時点では必須ではないためvalidatesを2つに分け、create,updateでそれぞれ機能するようにした