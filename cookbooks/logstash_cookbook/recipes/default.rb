#
# Cookbook:: logstash_cookbook
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.
apt_update("update") do
  action :update
end

package("openjdk-8-jdk") do
  action :install
end

bash("add_elasticsearch_key") do
  code "wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -"
  action :run
end

# Add the elasticsearch repository to install logstash
apt_repository("elastic5") do
  uri "https://artifacts.elastic.co/packages/5.x/apt"
  distribution "stable"
  components ["main"]
  action :add
end

apt_update("update") do
  action :update
end

package("logstash") do
  action :install
end

apt_repository("elastic6") do
  uri "https://artifacts.elastic.co/packages/6.x/apt"
  distribution "stable"
  components ["main"]
  action :add
end

package("logstash") do
  action :upgrade
end

file("/usr/share/logstash/bin/startup.options") do
  action :delete
end

template("/usr/share/logstash/bin/startup.options") do
  source "startup.options.erb"
end

file("/etc/logstash/jvm.options") do
  action :delete
end

template("/etc/logstash/jvm.options") do
  source "jvm.options.erb"
end

file("/etc/logstash/logstash.yml") do
  action :delete
end

template("/etc/logstash/logstash.yml") do
  source "logstash.yml.erb"
end

directory "/etc/logstash/conf.d" do
  action :create
end

template("/etc/logstash/conf.d/logstash.conf") do
  source "logstash.conf.erb"
end

service("logstash") do
  action [:enable, :start]
end
