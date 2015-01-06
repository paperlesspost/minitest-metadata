require "minitest-metadata"

require "minitest-metadata/array_fix"
require "minitest-metadata/filters"

module MinitestMetadataPatch

  VERSION = "0.0.1"

end

# Implement the patches
module Minitest
  module Metadata

    include MinitestMetadataPatch::ArrayFix
    include MinitestMetadataPatch::Filters

  end
end
