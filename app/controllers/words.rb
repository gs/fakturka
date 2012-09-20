def slownie(liczba)

#puts liczba
string = []
string1 =[]
  jednosci = Array["", "jeden", "dwa", "trzy", "cztery", "pięć", "sześć", "siedem", "osiem", "dziewięć"]
  dziesiatki = Array["", "dziesieć", "dwadzieścia", "trzydzieści", "czterdzieści", "piećdziesiąt", "sześćdziesiąt", "siedemdziesiąt", "osiemdziesiąt",  "dziewięćdziesiąt"]
  setki = Array[ "", "sto", "dwieście", "trzysta", "czterysta", "piećset", "sześćset", "siedemset", "osiemset", "dziewiećset"]
  nastki = Array["dziesieć", "jedenaście", "dwanaście", "trzynaście", "czternaście", "pietnaście", "szesnaście", "siedemnaście", "osiemnaście", "dziewiętnaście" ]
  tysiace = Array["tysiąc", "tysiące", "tysięcy"]
  miliony = Array["milion", "miliony", "milionów"]
    a=liczba.to_s.split(".")
    puts a
    grosze = "#{a[1].to_s}"

    cyfra = liczba.to_i # usuniecie ulamka przy zlot�wkach

    cyfra = cyfra.to_s.reverse #odwr�cenie dla wygody
    #cyfra = cyfra.to_a

    cyfra1= grosze.to_s.reverse # odwr�cenie dla wygody
    #cyfra1=cyfra.to_a

    i = cyfra.to_s.length # zliczanie cyfr zlot�wek

    if grosze.to_s == "00"
        j=0
    else
        j = cyfra1.to_s.length  # zliczanie cyfr grosze
    end

(string << (setki[cyfra[8].to_i-48].to_s + " ")) if (i > 8)

if (i > 7) then
    (string << (nastki[cyfra[6].to_i - 48].to_s + " ")) if (cyfra[7].to_i-48 == 1)
    unless (cyfra[7].to_i-48 == 1) then
        (string << (((dziesiatki[cyfra[7].to_i - 48].to_s + " ") + jednosci[cyfra[6].to_i-48].to_s) + " "))
    end
end
if (i > 6) 
  if cyfra[6].to_i-48  == 1
    string << miliony[0] + " "
  else
    string << jednosci[cyfra[6].to_i - 48] + " " + miliony[1] + " "
  end
end

  if (i == 6) then
      (string << (miliony[0] + " ")) if (cyfra[6].to_i - 48 == 1)
       if ((cyfra[6].to_i - 48 > 1) && (cyfra[6].to_i - 48 < 5)) then
        (string << (((jednosci[cyfra[3].to_i - 48].to_s + " ") + miliony[1].to_s) + " "))
    end
    if (cyfra[6].to_i - 48 > 4) then
        (string << (((jednosci[cyfra[6].to_i - 48].to_s + " ") + miliony[2].to_s) + " "))
    end

  end
(string << (setki[cyfra[5].to_i-48].to_s + " ")) if (i > 5)
if (i > 4) then
    (string << (nastki[cyfra[3].to_i - 48].to_s + " ")) if (cyfra[4].to_i-48 == 1)
    unless (cyfra[4].to_i-48 == 1) then
        (string << (((dziesiatki[cyfra[4].to_i - 48].to_s + " ") + jednosci[cyfra[3].to_i-48].to_s) + " "))
    end
end
if (i > 4) then
    if (cyfra[3].to_i - 48 == 1) then
        (string << (tysiace[1] + " "))
    else
        (string << (tysiace[2] + " "))
    end
end
if (i == 4) then
    (string << (tysiace[0] + " ")) if (cyfra[3].to_i - 48 == 1)
    if ((cyfra[3].to_i - 48 > 1) && (cyfra[3].to_i - 48 < 5)) then
        (string << (((jednosci[cyfra[3].to_i - 48].to_s + " ") + tysiace[1].to_s) + " "))
    end
    if (cyfra[3].to_i - 48 > 4) then
        (string << (((jednosci[cyfra[3].to_i - 48].to_s + " ") + tysiace[2].to_s) + " "))
    end
end
(string << (setki[cyfra[2].to_i - 48].to_s + " ")) if (i > 2)
if (i > 1) then
    (string << (nastki[cyfra[0].to_i - 48].to_s + " ")) if (cyfra[1].to_i - 48 == 1)
    unless (cyfra[1].to_i - 48 == 1) then
        (string << (((dziesiatki[cyfra[1].to_i - 48].to_s + " ") + jednosci[cyfra[0].to_i - 48].to_s) + " "))
    end
end
(string << (jednosci[cyfra[0].to_i - 48].to_s + " ")) if (i == 1)
if (j > 0)

    string1 << (nastki[cyfra1[0].to_i - 48].to_s + " ") if (cyfra1[1].to_i - 48 == 1)

    string1 << (dziesiatki[cyfra1[1].to_i - 48].to_s+ ' ' + jednosci[cyfra1[0].to_i - 48].to_s+  " ")  if (cyfra1[1].to_i - 48 != 1)

end

if (j == 1) then
    string1 << (jednosci[cyfra1[0].to_i - 48].to_s+  " ")
else
    string1 << "zero" if (grosze.to_s == "00")
end


 return (string.to_s + "ZŁ " + string1.to_s + " GR")

end

#slownie("233443.65")
