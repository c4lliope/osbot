class User
  def initialize(attrs)
    @handle = attrs.fetch(:handle)
    @token = attrs.fetch(:token)
    @image_url = attrs.fetch(:image_url)
  end

  attr_reader :handle, :token, :image_url

  def self.build_from_auth_hash(auth_hash)
    User.new(
      handle: auth_hash[:info][:nickname],
      image_url: auth_hash[:info][:image],
      token: auth_hash[:credentials][:token],
    )
  end

  def self.build_from_session_hash(session_hash)
    User.new(session_hash.with_indifferent_access)
  end

  def to_session_hash
    {
      handle: handle,
      token: token,
      image_url: image_url
    }
  end
end
