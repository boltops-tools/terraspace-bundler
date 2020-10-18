describe TB::Mod do
  let(:mod) { described_class.new(props) }
  let(:props) do
    {
      name: "example",
      source: "org/terraform-aws-vpc",
    }
  end

  context "normalize_stacks" do
    context "single String" do
      let(:stacks) { "vpc" }
      it "return List of Hashes" do
        options = mod.normalize_stacks(stacks)
        expect(options).to eq(
          [{:dest=>"app/stacks", :purge=>nil, :examples=>"examples", :src=>"vpc"}]
        )
      end
    end

    context "single Hash" do
      let(:stacks) { {src: "vpc"} }
      it "return List of Hashes" do
        options = mod.normalize_stacks(stacks)
        expect(options).to eq(
          [{:dest=>"app/stacks", :purge=>nil, :examples=>"examples", :src=>"vpc"}]
        )
      end
    end

    context "multiple Strings" do
      let(:stacks) { ["ec2", "vpc"] }
      it "return List of Hashes" do
        options = mod.normalize_stacks(stacks)
        expect(options).to eq(
          [{:dest=>"app/stacks", :purge=>nil, :examples=>"examples", :src=>"ec2"},
           {:dest=>"app/stacks", :purge=>nil, :examples=>"examples", :src=>"vpc"}]
        )
      end
    end

    context "multiple Hash" do
      let(:stacks) { [{src: "ec2"}, {src: "vpc"}] }
      it "return List of Hashes" do
        options = mod.normalize_stacks(stacks)
        expect(options).to eq(
          [{:dest=>"app/stacks", :purge=>nil, :examples=>"examples", :src=>"ec2"},
           {:dest=>"app/stacks", :purge=>nil, :examples=>"examples", :src=>"vpc"}]
        )
      end
    end

    context "multiple Objects" do
      let(:stacks) { ["ec2", {src: "vpc"}] }
      it "return List of Hashes" do
        options = mod.normalize_stacks(stacks)
        expect(options).to eq(
          [{:dest=>"app/stacks", :purge=>nil, :examples=>"examples", :src=>"ec2"},
           {:dest=>"app/stacks", :purge=>nil, :examples=>"examples", :src=>"vpc"}]
        )
      end
    end

    context "multiple Objects with options" do
      let(:stacks) { ["ec2", {src: "vpc", purge: true, dest: "vendor/stacks"}] }
      it "return List of Hashes" do
        options = mod.normalize_stacks(stacks)
        expect(options).to eq(
          [{:dest=>"app/stacks", :purge=>nil, :examples=>"examples", :src=>"ec2"},
           {:dest=>"vendor/stacks", :purge=>true, :examples=>"examples", :src=>"vpc"}]
        )
      end
    end
  end
end
