describe TB::Mod::OrgRepo do
  let(:org_repo) { described_class.new(url) }

  context "ssh://ec2-user@localhost/repo" do
    let(:url) { "ssh://ec2-user@localhost/repo" }
    it "org repo" do
      # puts "org_repo.org #{org_repo.org}"
      # puts "org_repo.repo #{org_repo.repo}"
      expect(org_repo.org_folder).to eq "localhost"
      expect(org_repo.repo_folder).to eq "localhost/repo"
    end
  end

  context "ssh://ec2-user@localhost/long/path/to/repo" do
    let(:url) { "ssh://ec2-user@localhost/long/path/to/repo" }
    it "org repo" do
      expect(org_repo.org_folder).to eq "localhost/long/path/to"
      expect(org_repo.repo_folder).to eq "localhost/long/path/to/repo"
    end
  end

  context "ec2-user@localhost:long/path/to/repo" do
    let(:url) { "ec2-user@localhost:long/path/to/repo" }
    it "org repo" do
      expect(org_repo.org_folder).to eq "localhost/long/path/to"
      expect(org_repo.repo_folder).to eq "localhost/long/path/to/repo"
    end
  end

  context "git@github.com:org/repo" do
    let(:url) { "git@github.com:org/repo" }
    it "org repo" do
      expect(org_repo.org_folder).to eq "github.com/org"
      expect(org_repo.repo_folder).to eq "github.com/org/repo"
    end
  end

  context "https://github.com/org/repo" do
    let(:url) { "https://github.com/org/repo" }
    it "org repo" do
      expect(org_repo.org_folder).to eq "github.com/org"
      expect(org_repo.repo_folder).to eq "github.com/org/repo"
    end
  end
end
