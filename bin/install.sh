#!/bin/bash --login
rvm gemset use offlook --create
gem install bundler --no-ri --no-rdoc
bundle
# guarantees full synching and credentials input
./syncher.rb -f