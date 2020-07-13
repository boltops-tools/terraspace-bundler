describe TB::Installer do
  let(:installer) { described_class.new }

  context "installer" do
    # hacky sanity check
    it "run" do
      FileUtils.rm_f("tmp/Terrafile.lock")
      FileUtils.mkdir_p("tmp")
      Dir.chdir("tmp")
      TB.config.terrafile = "spec/fixtures/Terrafile"
      installer.run
      file_exist = File.exist?("Terrafile.lock")
      expect(file_exist).to be true
    end
  end
end
