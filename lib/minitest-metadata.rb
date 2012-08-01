require "minitest-metadata/filters"
require "minitest-metadata/version"

module MiniTest
  module Metadata

    # Returns the metadata for the currently running test.
    def metadata
      self.class.metadata[__name__] || {}
    end

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods

      # Returns the metadata for the entire suite.
      def metadata
        @metadata ||= {}
      end

      # Overridden method (MiniTest::Spec.it): modified to record the metadata
      # for each test defined.
      def it(description = "anonymous", metadata = {}, &block)
        # Compares the methods defined before and after defining a test to get
        # the test's name.
        old_methods = test_methods(:filtered => false)
        super(description, &block).tap do
          new_methods = test_methods(:filtered => false)
          name = (new_methods - old_methods).first
          self.metadata[name] = metadata
        end
      end

      # Overridden method (MiniTest::Spec.test_methods): modified to return
      # the filtered test methods by default.
      def test_methods(options = {})
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

      # Applies all added filters.
      def apply_filters(methods)
        filters.inject(methods) { |methods, filter| filter.apply(methods, self) }
      end

      def metaclass
        class << self
          self
        end
      end

    end # ClassMethods

  end # Metadata
end # MiniTest
