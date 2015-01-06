require "minitest-metadata"

require "minitest-metadata_patch/array_fix"
require "minitest-metadata_patch/filters"

module MinitestMetadataPatch

  VERSION = "0.0.1"

  def self.included(base)
    base.send(:include, MinitestMetadataPatch::ArrayFix)
    base.send(:extend, MinitestMetadataPatch::Filters::ClassMethods)
  end

end

# Implement the patches
module Minitest

  module Metadata

    def self.included(base)
      base.send(:include, MinitestMetadataPatch)
      super
    end

  end
end
