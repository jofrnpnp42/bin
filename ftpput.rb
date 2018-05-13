#!/usr/bin/env ruby
require 'net/ftp'
require 'logger'

def help()
    printf("Usage: %s [local file]...\n", $0)
end

# デバッグログレベル
$log = Logger.new(STDOUT)
#$log.level = Logger::FATAL
#$log.level = Logger::ERROR
#$log.level = Logger::WARN
#$log.level = Logger::INFO
$log.level = Logger::DEBUG

Server   = "example.ftpserver"
Username = "username"
Password = "password"
Rdir     = "/tmp"

#--------- program start ---------#
if ARGV.length() < 1
    help(); exit(1)
end

ftp = Net::FTP.new 
ftp.connect(Server)
ftp.login(Username, Password)
ftp.binary = true
ftp.chdir(Rdir)
(1..ARGV.length()).each do |i|
    $log.debug sprintf("[%d] %s\n", i, ARGV[i-1])
    ftp.put(ARGV[i-1])
end
ftp.quit

