# Copyright (C) 2013 VMware, Inc.
require 'pathname'
provider_path = Pathname.new(__FILE__).parent.parent
require File.join(provider_path, 'vcsa')

Puppet::Type.type(:vcsa_sso).provide(:ssh, :parent => Puppet::Provider::Vcsa ) do
  @doc = 'Manages vCSA sso'

  def create
    transport.exec!("vpxd_servicecfg sso write #{resource[:dbtype]} #{resource[:server]} #{resource[:port]} #{resource[:instance]} #{resource[:user]} #{resource[:password]}")
  end

  def exists?
    result = transport.exec!('vpxd_servicecfg sso read')
    result = Hash[*result.split("\n").map{|x| x.split("=",2) if x =~ /^(?!Key not found)/ }.compact.flatten]
    result['SSO_TYPE'] != ""
  end
end

