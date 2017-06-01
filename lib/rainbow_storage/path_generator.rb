module RainbowStorage
  class PathGenerator
    attr_accessor :config

    def initialize(config)
      @config = config
    end

    # Add extension to path if present
    # do not add extra dot before extesion
    def filename(id, extension)
      path = filepath(id)
      return path if extension.nil?
      "#{path}.#{extension.gsub(/^\./, '')}"
    end

    # Convert string like `abcdefghi` to `ab/cd/ef/ghi`
    # to represent location on file system
    def filepath(id)
      tokens = hmac(id).chars.each_slice(2).map(&:join)
      result = []
      nesting_depth.times { result << tokens.shift }
      result << tokens.join
      result.join('/')
    end

    private

    def hmac(id)
      digest = OpenSSL::Digest.new('sha1')
      OpenSSL::HMAC.hexdigest(digest, hmac_key, id.to_s)
    end

    def hmac_key
      config.salt
    end

    def nesting_depth
      config.nesting
    end
  end
end
