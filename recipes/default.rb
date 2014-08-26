#
# Cookbook Name:: oracle
# Recipe:: default
#
# Copyright (C) 2014 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

unless ::Dir.exists?("/u01/app/oraInventory")
  include_recipe 'yum'
  include_recipe 'yum-epel'

  yum_repository 'ol6_latest' do
    description "Oracle Linux $releasever Latest ($basearch)"
    baseurl 'http://public-yum.oracle.com/repo/OracleLinux/OL6/latest/$basearch/'
    gpgkey 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-oracle'
    sslverify false
    enabled true
    action :create
  end

  # remote_file "/etc/pki/rpm-gpg/RPM-GPG-KEY-oracle" do
  #   source "https://public-yum.oracle.com/RPM-GPG-KEY-oracle-ol6"
  # end

  cookbook_file "RPM-GPG-KEY-oracle-ol6" do
    path "/etc/pki/rpm-gpg/RPM-GPG-KEY-oracle"
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

  directory "/u01/app/oracle/product/11.2.0/dbhome_1" do
    owner "oracle"
    group "oinstall"
    mode 00775
    recursive true
    action :create
  end

  execute "fixup /u01 owner" do
    command "chown -Rf oracle:oinstall /u01"
    # only_if { Etc.getpwuid(File.stat('/u01/app').uid).name != "oracle" }
  end

  execute "fixup /u01 mode" do
    user "oracle"
    command "chmod -R 775 /u01"
    # only_if { Etc.getpwuid(File.stat('/u01/app').uid).name != "oracle" }
  end

  remote_file "/home/oracle/p10404530_112030_Linux-x86-64_1of7.zip" do
    source node['oracle']['remote_installation_file_1']
    owner "oracle"
    group "oinstall"
    checksum "5d77b9aa18e068fdd268f989bb9a1790bc7cc02b452da44130465a1558bad261"
    action :create
  end

  remote_file "/home/oracle/p10404530_112030_Linux-x86-64_2of7.zip" do
    source node['oracle']['remote_installation_file_2']
    owner "oracle"
    group "oinstall"
    checksum "01d2dbc10868b209ac1932df0b3c2407a9e7d4583d30bcf6448eec889a2837a1"
    action :create
  end

  yum_package "unzip" do
    action :install
  end

  execute "unzip database 1 zip" do
    cwd "/home/oracle/"
    user "oracle"
    group "oinstall"
    command "unzip -o /home/oracle/p10404530_112030_Linux-x86-64_1of7.zip"
  end

  execute "unzip database 2 zip" do
    cwd "/home/oracle/"
    user "oracle"
    group "oinstall"
    command "unzip -o /home/oracle/p10404530_112030_Linux-x86-64_2of7.zip"
    # b1c8da72cb72d8682807f731377f45f7
  end

  cookbook_file "db.rsp" do
    owner "oracle"
    group "oinstall"
    path "/home/oracle/db.rsp"
  end

  execute "install oracle" do
    cwd "/home/oracle/database"
    user "oracle"
    command "./runInstaller -silent -noconfig -showProgress -force -responseFile  /home/oracle/db.rsp"
  end
end
