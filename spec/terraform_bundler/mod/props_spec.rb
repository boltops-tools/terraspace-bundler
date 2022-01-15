describe TB::Mod::Props do
  let(:props) { described_class.new(params) }
  let(:params) do
    {:args=>["webapp"], :options=>{:source=>"app.terraform.io/demo-qa/s3-webapp/aws", :clone_with=>clone_with}}
  end

  context "https" do
    let(:clone_with) { "https" }
    it "git to https" do
      url = props.clone_with("git@github.com:tongueroo/example-module.git")
      expect(url).to eq "https://github.com/tongueroo/example-module.git"

      url = props.clone_with("git@bitbucket.org:tongueroo/example-module.git")
      expect(url).to eq "https://bitbucket.org/tongueroo/example-module.git"

      url = props.clone_with("git@gitlab.com:tongueroo/example-module.git")
      expect(url).to eq "https://gitlab.com/tongueroo/example-module.git"
    end
  end

  context "https" do
    let(:clone_with) { "git" }
    it "https to git" do
      url = props.clone_with("https://github.com/tongueroo/example-module.git")
      expect(url).to eq "git@github.com:tongueroo/example-module.git"

      url = props.clone_with("https://bitbucket.org/tongueroo/example-module.git")
      expect(url).to eq "git@bitbucket.org:tongueroo/example-module.git"

      url = props.clone_with("https://gitlab.com/tongueroo/example-module.git")
      expect(url).to eq "git@gitlab.com:tongueroo/example-module.git"
    end
  end

  # context terrafile = evaulated Terrafile DSL results in these type of options being passed to Props#build
  context "terrafile" do
    let(:params) do
      {
        :args=>["repo"],
        :options=>{:source=>source},
        :source=>"git::ssh://ec2-user@localhost:/home/ec2-user/environment/repo",
        :name=>"repo",
        :type=>"git",
        :url=>"ssh:",
        :subfolder=>"ec2-user@localhost:/home/ec2-user/environment/repo", :ref=>nil

      }
    end
    context "git@github.com source" do
      let(:source) { "git@github.com:boltops-tools/terraform-aws-s3" }
      it "properties" do
        result = props.build
        expect(result).to eq(
          {:source=>"git@github.com:boltops-tools/terraform-aws-s3",
           :name=>"repo",
           :type=>"git",
           :url=>"git@github.com:boltops-tools/terraform-aws-s3",
           :subfolder=>nil,
           :ref=>nil}
        )
        expect(props.url).to eq "git@github.com:boltops-tools/terraform-aws-s3"
        expect(props.type).to eq "git"
        expect(props.source).to eq "git@github.com:boltops-tools/terraform-aws-s3"
      end
    end
    context "https://github.com source" do
      let(:source) { "https://github.com/boltops-tools/random_pet" }
      it "properties" do
        expect(props.url).to eq "https://github.com/boltops-tools/random_pet"
        expect(props.type).to eq "git"
        expect(props.source).to eq "https://github.com/boltops-tools/random_pet"
      end
    end
    context "explicit org source" do
      let(:source) { "boltopspro/terraform-aws-elasticache" }
      it "properties" do
        expect(props.url).to eq "https://github.com/boltopspro/terraform-aws-elasticache"
        expect(props.type).to eq "git"
        expect(props.source).to eq "boltopspro/terraform-aws-elasticache"
      end
    end
    context "terraform registry source" do
      let(:source) { "terraform-aws-modules/security-group/aws" }
      it "properties" do
        expect(props.url).to eq "https://github.com/terraform-aws-modules/terraform-aws-security-group"
        expect(props.type).to eq "registry"
        expect(props.source).to eq "terraform-aws-modules/security-group/aws"
      end
    end
    context "ssh with explicit user source" do
      let(:source) { "ssh://user@host:/path/to/repo" }
      it "properties" do
        result = props.build
        expect(result).to eq(
          {:source=>"ssh://user@host:/path/to/repo",
           :name=>"repo",
           :type=>"git",
           :url=>"user@host:/path/to/repo",
           :subfolder=>nil,
           :ref=>nil}
        )
      end
    end
    context "ssh with implied user source" do
      let(:source) { "ssh://host:/path/to/repo" }
      it "properties" do
        result = props.build
        expect(result).to eq(
          {:source=>"ssh://host:/path/to/repo",
           :name=>"repo",
           :type=>"git",
           :url=>"host:/path/to/repo",
           :subfolder=>nil,
           :ref=>nil}
        )
      end
    end

    context "ssh 2-level folder source" do
      let(:source) { "ssh://ec2-user@localhost:environment/repo" }
      it "properties" do
        result = props.build
        expect(result).to eq(
          {:source=>"ssh://ec2-user@localhost:environment/repo",
           :name=>"repo",
           :type=>"git",
           :url=>"ec2-user@localhost:environment/repo",
           :subfolder=>nil,
           :ref=>nil}
        )
      end
    end

    context "ssh 1-level folder source" do
      let(:source) { "ssh://ec2-user@localhost:repo" }
      it "properties" do
        result = props.build
        expect(result).to eq(
          {:source=>"ssh://ec2-user@localhost:repo",
           :name=>"repo",
           :type=>"git",
           :url=>"ec2-user@localhost:repo",
           :subfolder=>nil,
           :ref=>nil}
        )
      end
    end

    context "ssh without colon supports only absolute path source" do
      let(:source) { "ssh://ec2-user@localhost/home/ec2-user/repo" }
      it "properties" do
        result = props.build
        expect(result).to eq(
          {:source=>"ssh://ec2-user@localhost/home/ec2-user/repo",
           :name=>"repo",
           :type=>"git",
           :url=>"ssh://ec2-user@localhost/home/ec2-user/repo",
           :subfolder=>nil,
           :ref=>nil}
        )
      end
    end
  end
end
