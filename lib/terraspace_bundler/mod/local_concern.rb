class TerraspaceBundler::Mod
  module LocalConcern
    def local?
      source.starts_with?("/") ||
      source.starts_with?(".") ||
      source.starts_with?("..") ||
      source.starts_with?("~")
    end
  end
end
