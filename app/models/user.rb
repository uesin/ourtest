class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[facebook google_oauth2] #モジュールを追加
                                            #=[:facebook,:google_oauth2]
         has_many :posts
         #
          #ユーザ情報を検索するメソッドを追記
         def self.find_for_oauth(auth)#クラスメソッドクラスから使用可能
          #where条件に合う全てのレコードを取得
          user = User.where(uid: auth.uid, provider: auth.provider).first
         
          unless user #もしデーターベース内に情報がなかったらユーザー情報を作成
            user = User.create(
        uid:      auth.uid,
        provider: auth.provider,
        nickname:     auth.info.name,
        email:    User.dummy_email(auth),
        password: Devise.friendly_token[0, 20]
      )
    end

    user
  end

  private

  def self.dummy_email(auth)
    "#{auth.uid}-#{auth.provider}@example.com"
  end
end
