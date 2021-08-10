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
end
