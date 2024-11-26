#!/usr/bin/env ruby
# git does not store file mtimes
# This script sets the mtime of each file based on the values in index.html

require 'cgi'

ROW_REGEX = %r{<tr><td>.*?<a href="([^"]+)">.*?</td><td>.*?</td><td>(.*?)</td></tr>}

def update_timestamps(dir)
  Dir.chdir dir do
    File.read('index.html').scan(ROW_REGEX).each do |(p, t)|
      path = CGI::unescapeHTML(CGI::unescape(p))
      if File.basename(path) == 'index.html'
        update_timestamps(File.dirname(path))
      else
        time = Time.new(t)
        File.utime(time, time, path)
      end
    end
  end
end

update_timestamps 'dist'
