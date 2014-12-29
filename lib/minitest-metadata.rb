require "minitest-metadata/filters"
require "minitest-metadata/version"

module Minitest
  module Metadata

    # Returns the metadata for the currently running test.
    def metadata
      self.class.metadata[name] || {}
    end

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods

      # Returns the metadata for the entire suite.
      def metadata
        @metadata ||= {}
      end

      # Overridden method (Minitest::Spec.it): modified to record the metadata
      # for each test defined.
      def it(description = "anonymous", metadata = {}, &block)
        # Compares the methods defined before and after defining a test to get
        # the test's name.
        name = super(description, &block)
        self.metadata[name] = metadata
        name
      end

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

    end # ClassMethods

  end # Metadata
end # Minitest
