require 'zlib'
require 'fileutils'

# => https://gist.github.com/sinisterchipmunk/1335041

module Util
  module GZip

    # gzips the provided file into a StringIO
    def self.gzip(file)
      gz = StringIO.new("")
      z = Zlib::GzipWriter.new(gz)
      z.write IO.read(file)
      z.close # this is necessary!
      
      # z was closed to write the gzip footer, so
      # now we need a new StringIO
      StringIO.new gz.string
    end
    
    # un-gzips the given file, returning the
    # decompressed version as string
    def self.gunzip(file)
      z = Zlib::GzipReader.open(file)
      unzipped = z.read
      z.close
      unzipped
    end
  end
end


### Usage Example: ###
# 
# io = Util::GZip.gzip("./file.gz")
# 
# string = gunzip("./file.gz")
#