require 'rainbow_storage/configuration'
require 'rainbow_storage/manager'
require 'rainbow_storage/path_generator'

module RainbowStorage
  class << self
    def manager
      fail StorageNotConfiguredException unless config
      RainbowStorage::Manager.new(config, path_generator)
    end

    def path_generator
      RainbowStorage::PathGenerator.new(config)
    end
  end
end
