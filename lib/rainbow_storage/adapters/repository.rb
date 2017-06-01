require 'rainbow_storage/exceptions/unknown_adapter_exception'

module RainbowStorage
  module Adapters
    class Repository
      class << self
        def get(name)
          adapters[name] || fail(RainbowStorage::UnknownAdapterException, "Unknown adapter '#{name}'")
        end

        def adapters
          {
            s3: RainbowStorage::Adapters::S3::Adapter
          }
        end
      end
    end
  end
end
