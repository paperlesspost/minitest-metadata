module MiniTest
  module Metadata
    module Filters

      # A tag filter. If no tags are provided, all methods are returned. If
      # tags are provided, if a method matches any one of those tags, it's
      # returned.
      class Tags
        def initialize(*tags)
          @tags = Array(tags).map(&:to_s)
        end

        def apply(methods, suite)
          # Return all methods if there's nothing to filter by.
          return methods if @tags.empty?

          methods.find_all do |method|
            metadata = suite.metadata[method]
            tags = Array(metadata[:tags])
            # Skip this test if there are no tags defined.
            next if tags.empty?
            # Compare strings to strings, so symbols or strings can be used
            # interchangeably.
            tags.map!(&:to_s)
            (tags & @tags).any?
          end
        end
      end # Tags

    end # Filters
  end # Metadata
end # MiniTest
