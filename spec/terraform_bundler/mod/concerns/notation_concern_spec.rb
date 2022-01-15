class NotationTest
  include TB::Mod::Concerns::NotationConcern
end

describe NotationTest do
  let(:notation) { described_class.new }

  context "clean_notation" do
    it "cleans" do
      source = "git::ssh://ec2-user@localhost:/home/ec2-user/environment/repo"
      cleaned = notation.clean_notation(source)
      expect(cleaned).to eq "/home/ec2-user/environment/repo"

      source = "ssh://ec2-user@localhost:/home/ec2-user/environment/repo"
      cleaned = notation.clean_notation(source)
      expect(cleaned).to eq "/home/ec2-user/environment/repo"

      source = "ssh://ec2-user@localhost:/home/ec2-user/environment/repo//subfolder"
      cleaned = notation.clean_notation(source)
      expect(cleaned).to eq "/home/ec2-user/environment/repo//subfolder"

      source = "git::ssh://ec2-user@localhost:environment/repo"
      cleaned = notation.clean_notation(source)
      expect(cleaned).to eq "environment/repo"

      source = "ssh://ec2-user@localhost:~/environment/repo"
      cleaned = notation.clean_notation(source)
      expect(cleaned).to eq "~/environment/repo"

      source = "git::ssh://localhost:environment/repo"
      cleaned = notation.clean_notation(source)
      expect(cleaned).to eq "environment/repo"
    end
  end
end
