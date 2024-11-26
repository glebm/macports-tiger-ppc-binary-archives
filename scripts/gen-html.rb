#!/usr/bin/env ruby
require 'cgi'

CSS = <<CSS
body {
  background-color: Canvas;
  color: CanvasText;
  color-scheme: light dark;
  font-family: SFMono-Regular, Menlo, Monaco, Consolas, "Liberation Mono", "Courier New", monospace;
  font-size: 16px;
}
td, th {
  padding: 0.25rem 0.5rem;
}
td:nth-child(1), th:nth-child(1) { text-align: left; }
td:nth-child(2), th:nth-child(2) { text-align: right; }
td:nth-child(3), th:nth-child(3) { text-align: left; }
CSS

HTML_BEGIN = <<HTML
<!doctype HTML>
<html>
<head>
<meta charset="utf-8">
<title>MacPorts binary archives for Tiger PPC (experimental)</title>
<style>#{CSS}</style>
<body>
HTML

TABLE_BEGIN = <<HTML
<table>
<thead>
<tr><th>Archive</th><th>Size</th><th>Last modified</th></tr>
</thead>
<tbody>
HTML

TABLE_END = <<HTML
</tbody>
</table>
HTML

HTML_END = <<HTML
</body>
</html>
HTML

def path_icon(path)
  return '📁' if File.directory?(path)
  return '🗄️' if path =~ /\.(tbz2|tgz|tar|tbz|tlz|txz|xar|zip|cpgz|cpio)$/
  return '📜' if path =~ /\.(rmd160|pem)/
  '📝'
end

def make_link(path)
  url = CGI::escape(path)
  if File.directory?(path)
    url = "#{url}/index.html"
  end
  "<a href=\"#{CGI::escapeHTML url}\">#{CGI::escapeHTML path}</a>"
end

def path_size(path)
  return File.size(path) unless File.directory?(path)
  Dir[File.join(path, '*')].lazy.map { |p|
    next 0 if File.basename(p) == 'index.html'
    path_size(p)
  }.sum
end

def max_file_mtime(path)
  return File.mtime(path) unless File.directory?(path)
  Dir["#{path}/*"].lazy.map do |child_path|
    next if File.basename(child_path) == 'index.html' || child_path =~ /\.rmd160$/
    if File.directory?(child_path)
      max_file_mtime child_path
    else
      File.mtime child_path
    end
  end.reject(&:nil?).max
end

def gen_index(path, server_path)
  Dir.chdir path do
    File.open('index.html', 'w') do |f|
      f << HTML_BEGIN
      f << "<h1>#{CGI::escapeHTML server_path}</h1>\n"
      f << TABLE_BEGIN
      Dir['*'].each do |path|
        next if File.basename(path) == 'index.html'
        f << "<tr><td>#{path_icon path} #{make_link path}</td>"\
             "<td>#{path_size(path).to_s.gsub(/\B(?=(...)*\b)/, ',')}</td>"\
             "<td>#{CGI::escapeHTML(max_file_mtime(path).to_s).sub(/\+0000$/, 'UTC')}</td></tr>\n"
      end
      f << TABLE_END
      f << HTML_END
    end
    
    Dir['*'].each do |subdir|
      next unless File.directory?(subdir)
      gen_index(subdir, File.join(server_path, subdir))
    end
  end
end

gen_index 'dist', '/'

