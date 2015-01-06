module Minitest
  module Metadata

    # Returns the metadata for the currently running test.
    def metadata
      self.class.metadata[name] || {}
    end

    def self.included(base)
      base.extend(ClassMethods)
      base.extend(Filters::ClassMethods)
      super
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

    end # ClassMethods

  end # Metadata
end # Minitest
