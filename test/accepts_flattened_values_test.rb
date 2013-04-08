require "test_helper"

describe AcceptsFlattenedValues do
  describe "accepts_flattened_values_for" do
    before do
      @klass = Class.new
      @reflection = mock()
      @reflection.stubs(:collection?).returns(true)
      @reflection.stubs(:klass).returns(@klass)
      @reflection.stubs(:options).returns({})
      @klass.stubs(:add_autosave_association_callbacks)
      @klass.stubs(:reflect_on_association).returns(@reflection)
      @klass.send(:include, AcceptsFlattenedValues)
    end

    it "should define an instance getter and setter" do
      @klass.accepts_flattened_values_for(:pirates)
      assert @klass.new.respond_to?(:pirates_values), "defined getter pirates_values"
      assert @klass.new.respond_to?(:pirates_values=), "defined setter pirates_values="
    end

    describe "with instance" do
      before do
        @klass.accepts_flattened_values_for(:pirates)
        @klass.accepts_flattened_values_for(:mateys, attribute: :name)
        @klass.accepts_flattened_values_for(:scallywags, separator: "&")
        @instance = @klass.new
      end

      it "should flatten the values from the assocation" do
        values = [mock(value: "hi"), mock(value: "mom")]
        @instance.expects(:pirates).returns(values)
        @instance.pirates_values.must_equal("hi,mom")
      end

      it "should flatten the values with custom attribute" do
        values = [mock(name: "hi"), mock(name: "mom")]
        @instance.expects(:mateys).returns(values)
        @instance.mateys_values.must_equal("hi,mom")
      end

      it "should flatten the values with custom separator" do
        values = [mock(value: "hi"), mock(value: "mom")]
        @instance.expects(:scallywags).returns(values)
        @instance.scallywags_values.must_equal("hi&mom")
      end

      describe "with setter" do
        before do
          @value1 = mock()
          @value2 = mock()
          @relation1 = mock()
          @relation1.expects(:first_or_initialize).returns(@value1)
          @relation2 = mock()
          @relation2.expects(:first_or_initialize).returns(@value2)
        end

        it "should split the string into the association" do
          @klass.expects(:where).with(value: "hi").returns(@relation1)
          @klass.expects(:where).with(value: "mom").returns(@relation2)
          @instance.expects(:pirates=).with([@value1, @value2])
          @instance.pirates_values = "hi,mom"
        end

        it "should split the string into the association with custom attribute" do
          @klass.expects(:where).with(name: "hi").returns(@relation1)
          @klass.expects(:where).with(name: "mom").returns(@relation2)
          @instance.expects(:mateys=).with([@value1, @value2])
          @instance.mateys_values = "hi,mom"
        end

        it "should split the string into the association with custome separator" do
          @klass.expects(:where).with(value: "hi").returns(@relation1)
          @klass.expects(:where).with(value: "mom").returns(@relation2)
          @instance.expects(:scallywags=).with([@value1, @value2])
          @instance.scallywags_values = "hi&mom"
        end
      end
    end
  end
end
