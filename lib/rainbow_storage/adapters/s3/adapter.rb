require 's3'
require 'rainbow_storage/adapters/abstract_adapter'

module RainbowStorage
  module Adapters
    module S3
      class Adapter < RainbowStorage::Adapters::AbstractAdapter
        attr_accessor :bucket

        # TODO: should we deal with tempfiles here? or just return a data?
        def get(path)
          object = bucket.objects.find(path)
          tempfile = Tempfile.new
          tempfile.write(object.content)
          tempfile.rewind
          tempfile
        end

        def put(path, data)
          new_object = bucket.objects.build(path)
          new_object.content = data
          new_object.acl = :public_read
          new_object.save
          new_object.close
          new_object.unlink
        end

        def delete(path)
          object = bucket.objects.find(path)
          object.destroy
        end

        def public_url(path)
          object = bucket.objects.find(path)
          object.temporary_url(Time.now + 1800)
        end

        private

        def post_initialize
          @service = ::S3::Service.new(access_key_id: config[:access_key],
                                     secret_access_key: config[:secret_key])
          @bucket = @service.bucket(config[:bucket])
        end
      end
    end
  end
end
