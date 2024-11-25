class JsonWebToken
    JWT_SECRET_KEY = Rails.application.credentials.dig(:secret_key_base)

    def self.encode(payload, exp = 12.hours.from_now)
      payload[:exp] = exp.to_i
      JWT.encode(payload, JWT_SECRET_KEY)
    end

    def self.decode(token)
      body = JWT.decode(token, JWT_SECRET_KEY)[0]

      HashWithIndifferentAccess.new(body)
    end
end