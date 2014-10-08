require 'spec_helper'
describe 'java', :type => :define do
    context "fails on i568" do
        let :facts do
            {
                :architecture => "i586"
            }
        end
        let :title do
            "1.7.0_67"
        end
        it "non x64 should cause failure" do
            expect { subject }.to raise_error(/only x86_64 architecture supported/)
        end
    end
    context "test defaults" do
        let :facts do 
            {
                :architecture => "x86_64"
            }
        end
        let :title do
            "latest"
        end
        it { 
            should contain_package("jdk-latest").with(
                "ensure" => "present",
                "name"   => "jdk",
            )
        }
    end
    context "test specific version" do
        let :facts do
            {
                :architecture => "x86_64"
            }
        end
        let :title do
            "1.7.0_67"
        end
        it {
            # by default rpms from oracle are -fcs releases
            should contain_package("jdk-1.7.0_67").with(
                "ensure" => "1.7.0_67-fcs",
                "name"   => "jdk",
            )
        }
    end
    context "test custom package name; default release" do
        let :facts do
            {
                :architecture => "x86_64"
            }
        end
        let :title do
            "1.2.3"
        end
        let :params do
            {
                :package_name => 'foo-jdk-foo',
            }
        end
        it {
            should contain_package("foo-jdk-foo-1.2.3").with(
                "ensure" => "1.2.3-fcs",
                "name"   => "foo-jdk-foo",
            )
        }
    end
    context "test custom package name; no release" do
        let :facts do
            {
                :architecture => "x86_64"
            }
        end
        let :title do
            "1.2.3"
        end
        let :params do
            {
                :package_name    => 'foo-jdk-foo',
                :package_release => false,
            }
        end
        it {
            should contain_package("foo-jdk-foo-1.2.3").with(
                "ensure" => "1.2.3",
                "name"   => "foo-jdk-foo",
            )
        }
    end
    context "test custom package name; custom release" do
        let :facts do
            {
                :architecture => "x86_64"
            }
        end
        let :title do
            "1.2.3"
        end
        let :params do
            {
                :package_name    => 'foo-jdk-foo',
                :package_release => "bar",
            }
        end
        it {
            should contain_package("foo-jdk-foo-1.2.3").with(
                "ensure" => "1.2.3-bar",
                "name"   => "foo-jdk-foo",
            )
        }
    end

end 

