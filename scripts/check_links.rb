require 'find'
require 'nokogiri'
require 'net/http'
require 'uri'
require 'set'

# The directory to check
SITE_DIRECTORY = '_site'

# Set to store all found URLs to avoid checking the same URL multiple times
all_urls = Set.new

# A hash to store the source file for each URL for better error reporting
url_sources = {}

# Find all URLs in HTML and CSS files
Find.find(SITE_DIRECTORY) do |path|
  next if File.directory?(path)

  urls_in_file = []

  if path.match?(/\.html$/)
    doc = Nokogiri::HTML(File.read(path))
    # Find links in <a>, <link>, <script>, <img> tags
    doc.css('a[href]', 'link[href]', 'script[src]', 'img[src]').each do |tag|
      urls_in_file << (tag['href'] || tag['src'])
    end
    # Find links in meta tags
    doc.css('meta[content]').each do |tag|
      content = tag['content']
      urls_in_file << content if content.start_with?('http') || content.start_with?('/')
    end
    # Find links in ld+json
    doc.css('script[type="application/ld+json"]').each do |script|
      # This is a simple regex, a more robust solution might need a JSON parser
      script.content.scan(/"(https?:\/\/[^"]+)"/).flatten.each do |url|
        urls_in_file << url
      end
    end
  elsif path.match?(/\.css$/)
    # Find links in url() declarations in CSS
    File.read(path).scan(/url\((['"]?)(.*?)\1\)/).each do |match|
      urls_in_file << match[1]
    end
  end

  # Add found URLs to the main set and record their source
  urls_in_file.each do |url|
    next if url.nil? || url.strip.empty?
    all_urls.add(url.strip)
    url_sources[url.strip] ||= path
  end
end

puts "Found #{all_urls.size} unique URLs to check..."

broken_links_found = false

# Now, check each URL
all_urls.to_a.sort.each do |url|
  source_file = url_sources[url]

  # Ignore mailto, tel, and other special protocols
  if url.start_with?('mailto:') || url.start_with?('tel:') || url.start_with?('#')
    next
  end

  if url.start_with?('http://', 'https://')
    # External link
    begin
      uri = URI.parse(url)
      response = Net::HTTP.get_response(uri)
      unless response.is_a?(Net::HTTPSuccess) || response.is_a?(Net::HTTPRedirection)
        puts "BROKEN EXTERNAL LINK: #{url} (in #{source_file}) - Status: #{response.code}"
        broken_links_found = true
      end
    rescue => e
      puts "BROKEN EXTERNAL LINK: #{url} (in #{source_file}) - Error: #{e.message}"
      broken_links_found = true
    end
  elsif url.start_with?('/')
    # Internal link
    # Remove any anchors from the URL
    path_without_anchor = url.split('#').first
    # Construct the full path to the file on the local filesystem
    file_path = File.join(SITE_DIRECTORY, path_without_anchor)

    # If the path points to a directory, check for an index.html file inside it
    if File.directory?(file_path)
      file_path = File.join(file_path, 'index.html')
    end

    unless File.exist?(file_path)
      puts "BROKEN INTERNAL LINK: #{url} (in #{source_file})"
      broken_links_found = true
    end
  else
    # It's a relative link from within a page. This script doesn't handle these,
    # but they can be added if needed. For now, just report them.
    puts "SKIPPING RELATIVE LINK: #{url} (in #{source_file})"
  end
end

puts "\nLink check complete."
unless broken_links_found
  puts "No broken links found. Congratulations!"
end
