class Session < ApplicationRecord
  belongs_to :user
  validates :token_key, presence: true, uniqueness: true
  validates :status, presence: true, inclusion: { in: %w(active deleted) }

  class << self
    def authorized?(token, email)
      if token.present? && email.present?
        key = self.create_token_key(token, email)
        session = Session.find_by(token_key: key, status: "active")
        session.present?
      end
    end

    def logout(token, email)
      key = self.create_token_key(token, email)
      session = Session.find_by(token_key: key, status: "active")
      session.update(status: "deleted")
    end

    def create_token_key(token, email)
      secret = token.encode("ASCII")
      digest = OpenSSL::Digest.new("sha1")
      message = email.encode("ASCII")
      hmac = OpenSSL::HMAC.digest(digest, secret, message)
      key = Base64.strict_encode64(hmac)
      key
    end
  end
end
