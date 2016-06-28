module AuthToken
  def self.encode(payload)
    p 'coming'
    p payload
	  # payload[:exp] = payload[:exp].to_i
    # p payload[:exp]
	  JWT.encode(payload, Rails.application.secrets.secret_key_base)
	end

  def self.decode(token)
    p 'coming to decode'
    p token
    decoded = JWT.decode(token, Rails.application.secrets.secret_key_base)
    p 'decoded'
    p decoded
    HashWithIndifferentAccess.new(decoded[0])
  rescue
    nil
  end
end