require "minitest/autorun"
require "minitest-metadata-patch"

class MinitestMetadataTest < Minitest::Spec

  describe "metadata" do
    before do
      @parent = Class.new(Minitest::Spec) do
        include Minitest::Metadata
      end
    end

    describe "as a class method" do
      before do
        suite = Class.new(@parent) do
          it "foo", :tags => :deep do
            # empty
          end

          it "bar" do
            # empty
          end

          it "baz", :tags => [:deep, :money] do
            # empty
          end

          self
        end
        @metadata = suite.metadata
      end

      it "returns the metadata for all test methods" do
        assert_equal({:tags => :deep},              @metadata["test_0001_foo"])
        assert_equal({},                            @metadata["test_0002_bar"])
        assert_equal({:tags => [:deep, :money]},    @metadata["test_0003_baz"])
      end
    end

    describe "as an instance method" do
      before do
        @suite = Class.new(@parent) do
          it "foo", :tags => :deep do
            metadata
          end

          it "bar" do
            metadata
          end

          it "baz", :tags => [:deep, :money] do
            metadata
          end

          self
        end
      end

      it "returns the metadata for that test method" do
        assert_equal({:tags => :deep},              @suite.new("test_0001_foo").test_0001_foo)
        assert_equal({},                            @suite.new("test_0002_bar").test_0002_bar)
        assert_equal({:tags => [:deep, :money]},    @suite.new("test_0003_baz").test_0003_baz)
      end
    end
  end # "metadata"

  describe "filters" do
    describe "when none are applied" do
      before do
        parent = Class.new(Minitest::Spec) do
          include Minitest::Metadata
        end

        suite = Class.new(parent) do
          it "foo", :tags => :deep do
            # empty
          end

          it "bar" do
            # empty
          end

          it "baz", :tags => [:deep, :money] do
            # empty
          end

          it "qux", :tags => :shallow do
            # empty
          end

          self
        end
        @methods = suite.runnable_methods
      end

      it "returns all test methods defined" do
        assert_equal 4, @methods.count
        assert @methods.include? "test_0001_foo"
        assert @methods.include? "test_0002_bar"
        assert @methods.include? "test_0003_baz"
        assert @methods.include? "test_0004_qux"
      end
    end

    describe "when 1 is applied" do
      before do
        parent = Class.new(Minitest::Spec) do
          include Minitest::Metadata
          filter { MinitestMetadataPatch::Filters::Tags.new(:money) }
        end

        suite = Class.new(parent) do
          it "foo", :tags => :deep do
            # empty
          end

          it "bar" do
            # empty
          end

          it "baz", :tags => [:deep, :money] do
            # empty
          end

          it "qux", :tags => :shallow do
            # empty
          end

          self
        end
        @methods = suite.runnable_methods
      end

      it "returns all test methods defined with that tag" do
        assert_equal 1, @methods.count
        assert @methods.include? "test_0003_baz"
      end
    end

    describe "when 1 is applied with 2 tags" do
      before do
        parent = Class.new(Minitest::Spec) do
          include Minitest::Metadata
          filter { MinitestMetadataPatch::Filters::Tags.new(:deep, :money) }
        end

        suite = Class.new(parent) do
          it "foo", :tags => :deep do
            # empty
          end

          it "bar" do
            # empty
          end

          it "baz", :tags => [:deep, :money] do
            # empty
          end

          it "qux", :tags => :shallow do
            # empty
          end

          self
        end
        @methods = suite.runnable_methods
      end

      it "returns all test methods defined with both of those tags" do
        assert_equal 1, @methods.count
        assert @methods.include? "test_0003_baz"
      end
    end

    describe "when 2 are applied" do
      before do
        parent = Class.new(Minitest::Spec) do
          include Minitest::Metadata
          filter { MinitestMetadataPatch::Filters::Tags.new(:deep) }
          filter { MinitestMetadataPatch::Filters::Tags.new(:money) }
        end

        suite = Class.new(parent) do
          it "foo", :tags => :deep do
            # empty
          end

          it "bar" do
            # empty
          end

          it "baz", :tags => [:deep, :money] do
            # empty
          end

          it "qux", :tags => :shallow do
            # empty
          end

          self
        end
        @methods = suite.runnable_methods
      end

      it "returns all test methods defined with both of those tags" do
        assert_equal 1, @methods.count
        assert @methods.include? "test_0003_baz"
      end
    end

    describe "when a string is used" do
      before do
        parent = Class.new(Minitest::Spec) do
          include Minitest::Metadata
          filter { MinitestMetadataPatch::Filters::Tags.new("deep") }
        end

        suite = Class.new(parent) do
          it "foo", :tags => :deep do
            # empty
          end

          it "bar" do
            # empty
          end

          it "baz", :tags => [:deep, :money] do
            # empty
          end

          it "qux", :tags => :shallow do
            # empty
          end

          self
        end
        @methods = suite.runnable_methods
      end

      it "should have no effect on the results" do
        assert_equal 2, @methods.count
        assert @methods.include? "test_0001_foo"
        assert @methods.include? "test_0003_baz"
      end
    end

    describe "when a symbol is used" do
      before do
        parent = Class.new(Minitest::Spec) do
          include Minitest::Metadata
          filter { MinitestMetadataPatch::Filters::Tags.new(:deep) }
        end

        suite = Class.new(parent) do
          it "foo", :tags => "deep" do
            # empty
          end

          it "bar" do
            # empty
          end

          it "baz", :tags => ["deep", "money"] do
            # empty
          end

          it "qux", :tags => "shallow" do
            # empty
          end

          self
        end
        @methods = suite.runnable_methods
      end

      it "should have no effect on the results" do
        assert_equal 2, @methods.count
        assert @methods.include? "test_0001_foo"
        assert @methods.include? "test_0003_baz"
      end
    end

    describe "when an empty array is passed" do
      before do
        parent = Class.new(Minitest::Spec) do
          include Minitest::Metadata
          filter { MinitestMetadataPatch::Filters::Tags.new([]) }
        end

        suite = Class.new(parent) do
          it "foo", :tags => :deep do
            # empty
          end

          it "bar" do
            # empty
          end

          it "baz", :tags => [:deep, :money] do
            # empty
          end

          it "qux", :tags => :shallow do
            # empty
          end

          self
        end
        @methods = suite.runnable_methods
      end

      it "returns all test methods defined" do
        assert_equal 4, @methods.count
        assert @methods.include? "test_0001_foo"
        assert @methods.include? "test_0002_bar"
        assert @methods.include? "test_0003_baz"
        assert @methods.include? "test_0004_qux"
      end
    end
  end # "filters"
end # MetadataTest
