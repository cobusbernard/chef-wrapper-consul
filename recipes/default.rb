#
# Cookbook Name:: chef-wrapper-consul
# Recipe:: default
#
# Copyright (C) 2016 Cobus Bernard
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOnerLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#

instances = search(:node, "role:consul-server AND chef_environment:#{node.chef_environment}")
instances.sort_by!{ |n| n[:fqdn] }
instances.map!{ |n| n[:fqdn] }

node.set['consul']['config']['start_join'] = instances
node.set['consul']['config']['bind_addr'] = node['ipaddress']

include_recipe 'consul::default'

consul_ui 'consul-ui' do
  owner node['consul']['service_user']
  group node['consul']['service_group']
  version node['consul']['version']
end
