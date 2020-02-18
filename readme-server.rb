#!/usr/bin/env ruby
# Adapted by Donald Merand from the minimal Ruby server example given at:
# https://tiddlywiki.com/#Saving%20via%20a%20Minimal%20Ruby%20Server

require 'fileutils'
require 'optparse'
require 'webrick'

options = { backup: 'backup', port: 8000, root: '.' }

OptionParser.new do |opts|
  opts.on('-bDIR', '--backup DIR', 'Directory in which to store backups. Defaults to "backup"')
  opts.on('-h', '--help', 'Print this help screen') do
    puts opts
    exit 1
  end
  opts.on('-pPORT', '--port PORT', 'Port to serve from, defaults to 8000')
  opts.on('-rROOT', '--root ROOT', 'Root directory from which to serve, defaults to "."') do |o|
    opts[:root] = o.gsub('\\', '/')
  end
end.parse!(into: options)

BACKUP_DIR = options[:backup]

module WEBrick
   module HTTPServlet

      class FileHandler
         alias do_PUT do_GET
      end

      class DefaultFileHandler
         def do_PUT(req, res)
            if req.path == "/"
              file = "#{@config[:DocumentRoot]}/index.html"
            else
              file = "#{@config[:DocumentRoot]}#{req.path}"
            end
            res.body = ''
            unless Dir.exists? BACKUP_DIR
               Dir.mkdir BACKUP_DIR
            end
            FileUtils.cp(file, "#{BACKUP_DIR}/#{File.basename(file, '.html')}.#{Time.now.to_i.to_s}.html")
            File.open(file, "w+") {|f| f.puts(req.body)}
         end

         def do_OPTIONS(req, res)
            res['allow'] = "GET,HEAD,POST,OPTIONS,CONNECT,PUT,DAV,dav"
            res['x-api-access-type'] = 'file'
            res['dav'] = 'tw5/put'
         end

      end
   end
end

server = WEBrick::HTTPServer.new({:Port => options[:port], :DocumentRoot => options[:root]})

trap "INT" do
  puts "Shutting down..."
  server.shutdown
  exec "#{File.dirname(__FILE__)}/bin/rotate_backups.sh"
end

server.start
