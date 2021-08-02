module TerraspaceBundler::Mod::Concerns
  module LocalConcern
    def local?
      source.starts_with?("/")  ||
      source.starts_with?(".")  ||
      source.starts_with?("..") ||
      source.starts_with?("~")
    end
  end
end
