# To change this template, choose Tools | Templates
# and open the template in the editor.
class Main
  def startapp
    puts "\nuruchamiam serwer "
    system("start /min ruby script/server -e production")
    1.upto(5) do |i|
      print "."
      sleep 5
    end
    puts "OK"
    return
  end

  def stopapp
    puts "\nzatrzymuje serwer\n\n"

    system("system /min  fakturka\\thin stop")
    return
  end

  def runweb
    puts "\nOdpalam przegladarke\n\n"
    system("start /min firefox.exe http://localhost:3000/login")
    return
  
  end

  def main
    startapp
    runweb
  end
end
#wybur = 0
#  while wybur != 'q' do
#    puts "Wybierz akcje:"
#    puts "1 - uruchom aplikacje"
#    puts "2 - uruchom przegladarke"
#    puts "3 - zatrymaj aplikacje"
#    puts "----------------------"
#    puts "\n\n q - koniec"
#
#    print ">"
#    wybur = gets.chomp
#
#    if wybur.to_s == '1'
#      startapp
#    elsif wybur.to_s == '2'
#      runweb
#    elsif wybur.to_s == '3'
#      stopapp
#    elsif wybur.to_s == 'q'
#      exit
#    else
#      puts "nie ma takiej opcji"
#    end
#
#  end

start = Main.new
start.startapp
start.runweb

