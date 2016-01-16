require 'chef/resource/lwrp_base'

class Chef
  class Resource
    class ElasticsearchConfig < Chef::Resource::LWRPBase
      provides :es_instance

      self.resource_name = :es_instance
      actions :create, :delete
      default_action :create

      attribute :name, kind_of: String, name_attribute: true, required: true
      attribute :heap_size, kind_of: String, default: "1g"
      attribute :variables, kind_of: [Hash], default: nil
      attribute :source, kind_of: String, default: nil

    end
  end
end