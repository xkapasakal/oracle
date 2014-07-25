#
# Cookbook Name:: oracle
# Recipe:: default
#
# Copyright (C) 2014 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

# add the oracle repository

# remote_file "/etc/yum.repos.d/public-yum-ol6.repo" do
#   source "https://public-yum.oracle.com/public-yum-ol6.repo"
# end

# remote_file "/etc/pki/rpm-gpg/RPM-GPG-KEY-oracle" do
#   source "https://public-yum.oracle.com/RPM-GPG-KEY-oracle-ol6"
# end

# execute 'yum install oracle-rdbms-server-11gR2-preinstall -y'

# yum_repository 'oracle' do
#   description "Oracle RH6 Stable repo"
#   mirrorlist "https://public-yum.oracle.com/public-yum-ol6.repo"
#   gpgkey 'https://public-yum.oracle.com/RPM-GPG-KEY-oracle-ol6'
#   sslverify false
#   enabled true
#   action :create
# end

###################################################################################

include_recipe 'yum'

yum_repository 'ol6_latest' do
  description "Oracle Linux $releasever Latest ($basearch)"
  baseurl 'http://public-yum.oracle.com/repo/OracleLinux/OL6/latest/$basearch/'
  gpgkey 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-oracle'
  sslverify false
  enabled true
  action :create
end

remote_file "/etc/pki/rpm-gpg/RPM-GPG-KEY-oracle" do
  source "https://public-yum.oracle.com/RPM-GPG-KEY-oracle-ol6"
end

yum_package "oracle-rdbms-server-11gR2-preinstall" do
  # version "1.0-9.el6"
  action :install
end

# execute 'yum -y install oracle-rdbms-server-11gR2-preinstall'

# Change password of oracle user
user "oracle" do
  password "$1$usTJi6oU$hccVDEorX8Wu96BpjcHRA0" # oracle
  action :modify
end

# Alter /etc/security/limits.d/90-nproc.conf file
cookbook_file "90-nproc.conf" do
  path "/etc/security/limits.d/90-nproc.conf"
end

# Set oracle env vars
cookbook_file "oracle.bash_profile" do
  path "/home/oracle/.bash_profile"
end








