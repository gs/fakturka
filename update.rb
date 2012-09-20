#!/usr/bin/ruby
# To change this template, choose Tools | Templates
# and open the template in the editor.
puts "Uaktualnienie programu"

require 'date'
data = Date.today
 
#update on windows
if RUBY_PLATFORM=~/win/

  system("cd update && zip -r backup\"#{data}\".zip ../db/fakturka_dev.db && copy backup\"#{data}\".zip ..\\backup")
  system("cd update && wget.exe http://grechut.wniebie.pl/fakturka/update.zip")
  system("cd update && unzip -o update.zip -d ../")
  system("cd update && runme.rb")
  system("cd update && del update.zip && del backup\"#{data}\".zip && del runme.rb")

else

  system("cd update && zip -r backup\"#{data}\".zip ../db/* && cp backup\"#{data}\".zip ..//backup")
  system("cd update && wget http://grechut.wniebie.pl/fakturka/update.zip")
  system("cd update && unzip -o update.zip -d  ../")
  system("cd update && chmod +x runme.rb && ./runme.rb")
  system("cd update && rm update.zip && rm backup\"#{data}\".zip && rm runme.rb")

end
