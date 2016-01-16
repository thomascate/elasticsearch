# elasticsearch-cookbook

Basic Elasticsearch cookbook for my ES test environment

## Supported Platforms

Debian

## Usage

This cookbook will install Elasticsearch and Java as well as provide a resource for configuring ES instances. This resource simply takes a hash named config for its variables and dumps that into elasticsearch.yml as yaml.

### elasticsearch::default

Include `elasticsearch` in your node's `run_list`:

```
include_recipe 'elasticsearch'

es_instance 'mycluster' do
  action :create
  heap_size "8g"
  variables :config => {
    "cluster" => {
      "name" => "mycluster"
    },
    "node" => { 
      "name" => node[:fqdn],
      "data" => true,
      "master" => true
    },
    "network" => {
      "bind_host" => "0.0.0.0",
      "publish_host" => node['network']['interfaces']['eth1']['addresses'].keys[1]
    },
    "path" => {
      "data" => "/var/lib/elasticsearch"
    },
    "discovery" => { "zen" => {
      "ping" => { 
        "multicast" => { "enabled" => true }
      },
      "minimum_master_nodes" => 2,
    } }
  }
end

service 'elasticsearch-mycluster' do
  supports :status => true, :restart => true, :reload => true
  action [:start, :enable]
end

```

## License and Authors

MIT license

Author:: Thomas Cate (<tcate@chef.io>)
