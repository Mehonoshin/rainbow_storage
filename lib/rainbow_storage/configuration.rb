module RainbowStorage
  class Configuration
    attr_accessor :salt, :nesting, :adapter, :adapter_config

    def initialize
      @salt = 'default_salt'
      @nesting = 3
    end
  end

  class << self
    def setup
      yield(config)
    end

    def config
      @config ||= RainbowStorage::Configuration.new
    end
  end
end
