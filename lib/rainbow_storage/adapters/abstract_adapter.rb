module RainbowStorage
  module Adapters
    class AbstractAdapter
      attr_accessor :config

      def initialize(config)
        @config = config
        post_initialize
      end

      def get(path)
        fail NotImplementedError
      end

      def put(path, data)
        fail NotImplementedError
      end

      def delete(path)
        fail NotImplementedError
      end

      def public_url(path)
        fail NotImplementedError
      end

      private

      # Hook-method to add custom initialization logic to adapter
      def post_initialize
      end
    end
  end
end
