module Minitest
  module Metadata
    module Filters
      # A tag filter. If no tags are provided, all methods are returned. If
      # tags are provided, if a method has all of those tags, it's returned.
      class Tags
        def initialize(*filter_tags)
          @filter_tags = sanitize_tags(filter_tags)
        end

        # Returns test methods filtered by the filter tags.
        def apply(methods, suite)
          methods.find_all do |method|
            metadata = metadata_from_suite(suite, method)
            test_tags = test_tags_from_metadata(metadata)
            test_tags_include_all_filter_tags?(test_tags)
          end
        end

      private

        # Forces tags to be a single-dimensional array of strings.
        def sanitize_tags(tags)
          Array(tags).flatten.map(&:to_s)
        end

        # Returns test tags from a method's metadata.
        def test_tags_from_metadata(metadata)
          sanitize_tags(metadata[:tags])
        end

        # Returns the metadata from a suite, for a test method.
        def metadata_from_suite(suite, method)
          suite.metadata[method]
        end

        # Returns true if the test tags include all of the filter tags (an AND
        # operation, as opposed to an OR operation).
        def test_tags_include_all_filter_tags?(test_tags)
          (@filter_tags - test_tags).empty?
        end
      end # Tags
    end # Filters
  end # Metadata
end # Minitest
