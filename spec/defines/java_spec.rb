require 'spec_helper'
describe 'java', :type => :define do
    context "defaults fails" do
        let :facts do
            {
                :osfamily => "redhat",
            }
        end
        let :title do
            "foobar"
        end
        it { 
            expect { subject }.to raise_error(/must supply download_site/)
        }
    end
    context "fails on non-redhat os family" do
        let :facts do
            {
                :osfamily => "debian",
            }
        end
        let :title do
            "jdk-1.7.0_67-fcs.x86_64"
        end
        it {
            expect { subject }.to raise_error(/only supports the RedHat/)
        }
    end
    context "default rpm filename must fail" do
        let :facts do
            {
                :osfamily => "redhat",
            }
        end
        let :title do
            "jdk-7u67-linux-x64.rpm"
        end
        let :params do
            {
                :download_site => "http://foobar.com/",
            }
        end
        it {
            expect { subject }.to raise_error(/must be renamed/)
        }
    end
    context "ensure=>absent must uninstall" do
        let :facts do
            {
                :osfamily => "redhat",
            }
        end
        let :title do
            "jdk-1.7.0_62-fcs.x86_64"
        end
        let :params do
            {
                :ensure       => "absent",
            }
        end
        it {
            should contain_package("jdk-1.7.0_62-fcs.x86_64").with(
                "provider" => "rpm",
                "ensure"   => "absent",
            )
        }
    end
    context "uses rpm to install package" do
        let :facts do
            {
                :osfamily => "redhat",
            }
        end
        let :title do
            "jdk-1.7.0_67-fcs.x86_64"
        end
        let :params do
            {
                :download_site   => "http://foobar.com",
            }
        end
        it {
            should contain_package("jdk-1.7.0_67-fcs.x86_64").with(
                "ensure"          => "present",
                "name"            => "jdk-1.7.0_67-fcs.x86_64",
                "provider"        => "rpm",
                "install_options" => "--oldpackage",
            )
        }
    end
    context "install_options evaluated if set" do
        let :facts do
            {
                :osfamily => "redhat",
            }
        end
        let :title do
            "jdk-1.7.0_67-fcs.x86_64"
        end
        let :params do
            {
                :download_site   => "http://foobar.com/",
                :install_options => "--foobar",
            }
        end
        it {
            should contain_package("jdk-1.7.0_67-fcs.x86_64").with(
                "ensure"          => "present",
                "name"            => "jdk-1.7.0_67-fcs.x86_64",
                "provider"        => "rpm",
                "install_options" => "--foobar",
            )
        }
    end
    context "local_dir must be created" do
        let :facts do
            {
                :osfamily => "redhat",
            }
        end
        let :title do
            "jdk-1.7.0_67-fcs.x86_64"
        end
        let :params do
            {
                :download_site   => "http://foobar.com/",
                :local_dir       => "/var/repos/foo",
            }
        end
        it {
            should contain_file("/var/repos/foo").with(
                "ensure"          => "directory",
            )
        }
    end
end 

