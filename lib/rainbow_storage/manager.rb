require 'rainbow_storage/adapters/s3'
require 'rainbow_storage/adapters/repository'
require 'rainbow_storage/exceptions/unsupported_file_type_exception'
require 'open-uri'

module RainbowStorage
  class Manager
    attr_accessor :config, :path_generator

    def initialize(config, path_generator)
      @config         = config
      @path_generator = path_generator
    end

    # TODO: maybe introduce RainbowStorage::File class for path, extension, content and content-type?
    # Usage examples:
    # RainbowStorage.manager.upload({file: URI('http://site.com/files/1358_1495284100.jpg'), id: 1, extension: '.jpg'})
    def upload(options = {})
      validate_upload_options!(options)

      file      = options[:file]
      id        = options[:id]        || "#{file.object_id}#{Time.now.to_i}"
      extension = options[:extension] || infer_extenstion_from_file(file)

      content = case file
      when Tempfile
        file.rewind
        file.read
      when URI
        open(file.to_s).read
      else
        fail RainbowStorage::UnsupportedFileTypeException,
          "#{file.class} is not valid type for file attribute"
      end

      path = path_generator.filename(id, extension)
      adapter.put(path, content)
    end

    # Usage example:
    # RainbowStorage.manager.download(1, '.jpg')
    def download(id, extension = nil)
      path = path_generator.filename(id, extension)
      adapter.get(path)
    end

    # Usage example:
    # RainbowStorage.manager.remove(1, 'jpg')
    def remove(id, extension = nil)
      path = path_generator.filename(id, extension)
      adapter.delete(path)
    end

    # Usage example:
    # RainbowStorage.manager.link(1, 'jpg')
    def link(id, extension = nil)
      path = path_generator.filename(id, extension)
      adapter.public_url(path)
    end

    private

    def validate_upload_options!(options)
    end

    def infer_extension_from_file(file)
    end

    def adapter
      @adapter ||= RainbowStorage::Adapters::Repository.get(config.adapter).new(config.adapter_config)
    end
  end
end
