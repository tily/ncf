require "bundler/gem_tasks"

desc 'vup'
task :vup do
        version = ENV['VERSION']
        File.open('lib/ncf/version.rb', 'w') do |f|
                f.write <<-EOF
module Ncf
        VERSION = "#{version}"
end
                EOF
        end
        system "git add lib/ncf/version.rb"
        system "git tag v#{version} -m v#{version}"
        system "git commit -m 'version up to #{version}'"
        system "git push origin master"
        system "git push --tags"
        system "rake build"
        system "gem push pkg/ncf-#{version}.gem"
end
