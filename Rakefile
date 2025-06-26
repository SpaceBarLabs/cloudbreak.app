require 'html-proofer'

desc "Build the site and check for broken links"
task :test do
  puts "Building site..."
  system "bundle exec jekyll build"
  puts "Checking for broken links..."
  HTMLProofer.check_directory("./_site").run
end
