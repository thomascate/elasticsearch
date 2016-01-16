module ElasticsearchCookbook
  module Helpers
    include Chef::DSL::IncludeRecipe

    def config_path
      "/etc/elasticsearch"
    end

  end
end
