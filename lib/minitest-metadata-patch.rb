require "minitest-metadata-patch/array_fix"
require "minitest-metadata-patch/filters"

# Activate the patches
module Minitest

  module Metadata

    def self.included(base)
      base.send(:include, MinitestMetadataPatch::ArrayFix::InstanceMethods)
      base.send(:extend, MinitestMetadataPatch::ArrayFix::ClassMethods)
      base.send(:extend, MinitestMetadataPatch::Filters::ClassMethods)
      super
    end

  end
end
