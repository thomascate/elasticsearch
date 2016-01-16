require 'chef/provider/lwrp_base'
require_relative 'helpers'

class Chef
  class Provider
    class ElasticsearchInstance < Chef::Provider::LWRPBase
      include ElasticsearchCookbook::Helpers
      provides :es_instance if defined?(provides)
      action :create do

        instance_path = "#{config_path}/#{new_resource.name}"

        directory "#{instance_path}" do
          owner 'elasticsearch'
          group 'elasticsearch'
          mode '0755'
          recursive true
          action :create
        end
        

        template "#{instance_path}/elasticsearch.yml" do
          source 'instance.erb'
          cookbook 'elasticsearch'
          owner 'elasticsearch'
          group 'elasticsearch'
          mode '0644'
          variables(new_resource.variables)
        end

        template "#{instance_path}/logging.yml" do
          source 'logging.erb'
          cookbook 'elasticsearch'
          owner 'elasticsearch'
          group 'elasticsearch'
          mode '0644'
        end

        template "/etc/init.d/elasticsearch-#{new_resource.name}" do
          source 'init.erb'
          cookbook 'elasticsearch'
          owner 'root'
          group 'root'
          mode '0755'
          variables({
            :name => new_resource.name
          })
        end

        template "/usr/lib/systemd/system/elasticsearch-#{new_resource.name}.service" do
          source 'sysdinit.erb'
          cookbook 'elasticsearch'
          owner 'root'
          group 'root'
          mode '0644'
          variables({
            :name => new_resource.name
          })
        end

        template '/etc/default/elasticsearch' do
          source 'defaults.erb'
          cookbook 'elasticsearch'
          owner 'root'
          group 'root'
          mode '0644'
          variables({
            :heap_size => new_resource.heap_size
          })
        end

        #clean up the default config files, since they should never be used
        default_files = [
        '/etc/init.d/elasticsearch',
        '/usr/lib/systemd/system/elasticsearch.service',
        '/etc/elasticsearch/elasticsearch.yml',
        '/etc/elasticsearch/logging.yml'
        ]

        default_files.each do |filename|
          file filename do
            action :delete
            notifies :run, 'execute[disable_service]', :delayed
          end
        end

        execute 'disable_service' do
          command 'systemctl disable elasticsearch.service'
          action :nothing
        end

      end
    end
  end
end
