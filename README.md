# Primitive executable gem for making and extracting tar archives

## Installation

Download project:

    $ git clone https://github.com/rekero/tar-archive.git

Make gem:

    $ gem build tar_archive.gemspec

Then install it:

    $ gem install tar_archive-3.14.15.gem

## About functionality
* insert: write all files into one big archive
* checksum: count checksum for headers
* extract: read archive
* get_header: create header for untarred file
* read_file: get content for untarred file


#TODO
headers for unpacked files, tests
