module MinitestMetadataPatch

  module Filters

    def self.included(base)
      base.send(:extend, ClassMethods)
    end

    module ClassMethods

      # Overridden method (Minitest::Spec.runnable_methods): modified to return
      # the filtered test methods by default.
      def runnable_methods(options = {})
        filtered = true unless options[:filtered] == false
        methods = super()
        return methods unless filtered && filters?
        # Delegate to the filter classes to apply themselves.
        apply_filters(methods)
      end

      # Defines a inheritable filter. Must respond to the +apply+ method, with parameters
      # +methods+ and +suite+.
      def filter(&block)
        filters = self.filters << yield
        metaclass.send(:define_method, :_filters) do
          filters
        end
      end

      # Returns all added filters.
      def filters
        if metaclass.method_defined? :_filters
          self._filters
        else
          []
        end
      end

      def filters?
        filters.any?
      end

      private

      def all_test_methods
        self.public_instance_methods.grep(/^test_/).map(&:to_s)
      end

      # Applies all added filters.
      def apply_filters(methods)
        filters.inject(methods) { |methods, filter| filter.apply(methods, self) }
      end

      def metaclass
        class << self
          self
        end
      end

    end

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
