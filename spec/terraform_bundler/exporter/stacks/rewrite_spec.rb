describe TB::Exporter::Stacks::Rewrite do
  let(:rewrite) { described_class.new(options) }
  let(:options) do
    {
      folder: "whatever",
      mod_name: "stack_name",
    }
  end
  # let(:stack) do
  #   stack = double(:stack).as_null_object
  #   allow(stack).to receive(:name).and_return("stack_name")
  #   stack
  # end

  before(:each) do
    allow(IO).to receive(:write) do |path, text|
      @text = text
    end
  end

  context "has path-based module" do
    let(:path) { fixture("rewrite/normal.tf") }
    it "replace" do
      rewrite.replace(path)
      replaced = @text.include?('source = "../../modules/stack_name"')
      expect(replaced).to be true
    end
  end

  context "has path-based module with lots of extra spaces in between" do
    let(:path) { fixture("rewrite/spaces.tf") }
    it "replace" do
      rewrite.replace(path)
      replaced = @text.include?('source = "../../modules/stack_name"')
      expect(replaced).to be true
    end
  end

  context "has path-based module with lots of no spaces inbetween" do
    let(:path) { fixture("rewrite/no-spaces.tf") }
    it "replace" do
      rewrite.replace(path)
      replaced = @text.include?('source = "../../modules/stack_name"')
      expect(replaced).to be true
    end
  end

  context "has path-based module with no leading spaces" do
    let(:path) { fixture("rewrite/no-leading.tf") }
    it "replace" do
      rewrite.replace(path)
      replaced = @text.include?('source = "../../modules/stack_name"')
      expect(replaced).to be true
    end
  end

  context "module is within subfolder and not at root" do
    let(:path) { fixture("rewrite/module-subfolder.tf") }
    it "replace" do
      rewrite.replace(path)
      replaced = @text.include?('source = "../../modules/stack_name/modules/iam-user"')
      expect(replaced).to be true
    end
  end

  context "example is within subfolder of module examples" do
    let(:path) { fixture("rewrite/example-subfolder.tf") }
    it "replace" do
      rewrite.replace(path)
      replaced = @text.include?('source = "../../modules/stack_name/modules/compute_instance"')
      expect(replaced).to be true
    end
  end

  context "trailing slash" do
    let(:path) { fixture("rewrite/trailing-slash.tf") }
    it "replace" do
      rewrite.replace(path)
      replaced = @text.include?('source = "../../modules/stack_name"')
      expect(replaced).to be true
    end
  end

  context "not a path-based module" do
    let(:path) { fixture("rewrite/no-path.tf") }
    it "replace" do
      rewrite.replace(path)
      kept = @text.include?('source = "hashicorp/consul/aws"') # keeps current source link
      expect(kept).to be true
    end
  end
end
