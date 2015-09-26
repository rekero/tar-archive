require "tar_archive/version"

module TarArchive
  class Tar
    def insert (*files, output, path)
      out = File.open(path + '/' + output, 'w')
      files.flatten.each do |file_name|
        name = file_name
        full_file_name = path + '/' + name
        raise 'no file' unless File.exist?(full_file_name)
        file = File.open(full_file_name, 'r')
        if name.length > 100
            raise "file name is too long" if name.length > 255
            name, prefix = file[0..99], file[100..-1]
          else
            prefix = ""
        end
        # http://www.gnu.org/software/tar/manual/html_node/Standard.html
        header = "#{name}" + ("\0" * (100 - name.length))
        # name
        header += "%.7o\0" % '0644'
        # mode (permissions)
        header += "%.7o\0" % Process.euid
        # uid (permissions)
        header += "%.7o\0" % Process.egid
        # gid (permissions)
        header += "%.11o\0" % file.size
        # file size
        header += "%.11o\0" % Time.new
        # time
        header += " " * 8
        # checksum
        header += "%.1o" % 0
        # type of file
        header += "\0" * 100
        # linkname
        header += "ustar  \0"
        # magic + version
        header += "\0" * (32)
        # username (permissions)
        header += "\0" * (32)
        # groupname (permissions)
        header += "\0" * 16
        # device specifications
        header += "#{prefix}" + ("\0" * (155 - prefix.length))
        # prefix
        header += "\0" * 12
        # additional zeroes
        header = header[0..147] + checksum(header) + header[156..-1]
        # checksum
        out.write(header)
        until file.eof?
          buffer = file.read(512)
          out.write(buffer)
          out.write("\0" * (512 - (buffer.length % 512)))
        end
        file.close
      end
      out.write("\0" * 1024)
      out.close
    end

    def extract(output, path)
      file_name = path + '/' + output
      raise 'no file' unless File.exist?(file_name)
      out = File.open(file_name, 'r')
      until out.eof?
        while header = get_header(out)
          file = File.open(path + '/' + header[:name] + header[:prefix], 'w+')
          file.write(read_file(out, header[:size]))
        end
      end
      out.close
    end

    def read_file(file, size)
      text = file.read(size)
      file.read(512 - (size % 512))
      text
    end

    def get_header(out)
     data = out.read(512)
     return nil if data.strip == ''
     return nil if out.eof?
     header = {}
     header[:name] = data[0..99].strip
     header[:size] = data[124..135].strip.to_i
     header[:prefix] = data[345..500].strip
     check = checksum(data)
     header[:chksum] = data[148..155]
     raise "#{header[:name] + header[:prefix]}: bad file" unless header[:chksum] == check
     header
    end

    def checksum(header)
      "%.6o\0 " % (header[0..147] + header[156..500]).each_byte.inject(32*8, :+)
      # we should count checksum as eight zeroes
    end
  end
end
