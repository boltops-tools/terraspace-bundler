describe TB::CLI::Runner do
  let(:runner) { described_class.new }

  context "runner" do
    # hacky sanity check
    it "run" do
      FileUtils.mkdir_p("tmp")
      FileUtils.rm_f("tmp/Terrafile.lock")
      FileUtils.cp("spec/fixtures/Terrafile", "tmp/Terrafile")
      Dir.chdir("tmp")
      runner.run
      # since no mods are configured
      file_exist = File.exist?("Terrafile.lock")
      expect(file_exist).to be false
    end
  end
end
