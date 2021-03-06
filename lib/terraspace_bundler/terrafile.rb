module TerraspaceBundler
  class Terrafile
    include Singleton
    extend Memoist
    include TB::Util::Logging

    # dsl meta example:
    # {:global=>{:org=>"boltopspro"},
    # :mods=>
    #   [{:args=>["eks"], :options=>{:source=>"terraform-aws-eks"}},
    #   {:args=>["vpc"], :options=>{:source=>"terraform-aws-vpc"}}]}
    def mods
      TB.dsl.meta[:mods].map do |params|
        new_mod(params)
      end
    end
    memoize :mods

    def new_mod(params)
      props = Mod::PropsBuilder.new(params).build
      Mod.new(props)
    end

    # Checks if any of the mods defined in Terrafile has an inferred an org
    # In this case the org must be set
    # When a source is set with an inferred org and org is not set it looks like this:
    #
    #     dsl.meta has {:source=>"terraform-random-pet"}
    #     mod.source is /terraform-random-pet
    #
    # Using info to detect that the org is missing and the Terrafile definition
    # has at least one mod line that has an inferred org.
    #
    def missing_org?
      !!mods.detect { |mod| mod.source.starts_with?('/') }
    end
  end
end
