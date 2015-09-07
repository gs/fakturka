require 'words'
class FakturkaController < ApplicationController
  before_filter :login_required

  def index
    session['m_w']=nil
    session['edit'] = nil
    session['data_w']=nil
    session['data_s']=nil
    session['termin']=nil
    session['id_k'] = nil
    session['id_w'] = nil
    session['nr_f'] = nil
    session['poz']=nil
    redirect_to :action => "list"
  end

  def list
    reset if params[:r]
    session['m_w']="Nowy Sącz" if session['m_w'] == nil
    session['data_w']=Date.today if session['data_w'] == nil
    session['data_s']=Date.today if session['data_s'] == nil
    session['termin']=Date.today if session['termin'] == nil
    #  @data = Time.now.strftime("%y")
    #  @ile_f = Towar.count_by_sql("Select count(id) from fak_kont_suma where nr_faktury like \"%/#{@data}/%\" and user_id = #{current_user.id}")
    #  session['nr_f']= "#{@ile_f.to_i+1}/#{@data}/H" if session['nr_f']==nil
    @p = current_user.id
#    @zalegle = Towar.count_by_sql("Select count(id) from fak_kont_suma where stan_faktury like 0 and user_id = #{@p}")
    @zalegle = (FakKontSuma.find_all_by_stan_faktury_and_user_id 0,@p).size
    @pozycja = nil
  end

  def new
    if params[:q]
      @nr_f = session['nr_f']
      @u_id = current_user.id
      @id_w = session['id_w']
      @p = Towar.find_by_sql("select pozycja, uwagi from fak_kont_suma where nr_faktury=\"#{@nr_f}\" and user_id = \"#{@u_id}\" and id_wystawcy = #{@id_w}")
      @p.each do |item|
        session['poz'] = item.pozycja
        session['uwagi'] = item.uwagi
      end
      Towar.find_by_sql("delete from faktury where nr_faktury=\"#{@nr_f}\" and user_id = \"#{@u_id}\" and id_wystawcy = #{@id_w} " )
      Towar.find_by_sql("delete from fak_kont_suma where nr_faktury=\"#{@nr_f}\" and user_id = \"#{@u_id}\" and id_wystawcy = #{@id_w}")
    end
    session['m_w']="Nowy Sącz" if session['m_w'] == nil
    session['data_w']=Date.today if session['data_w'] == nil
    session['data_s']=Date.today if session['data_s'] == nil
    session['termin']=Date.today if session['termin'] == nil
    #@data = Date.today
    # @data = Time.now.strftime("%y")
    #@ile_f = Towar.count_by_sql("Select count(id) from fak_kont_suma where nr_faktury like \"%/#{@data}/%\" and user_id = #{current_user.id}")
    #session['nr_f']= "#{@ile_f.to_i+1}/#{@data}/H" if session['nr_f']==nil
    flash[:notice] = params[:msg] if params[:msg]
    session['id_k'] = params[:id_k] if params[:id_k]
    session['id_w'] = params[:id_w] if params[:id_w]
    #@kontrahent=Kontrahent.find(:first, :conditions => "id = #{session['id_k']}") if session['id_k']
    @kontrahent=KontrahentFakturowany.find(:first, :conditions => "id = #{session['id_k']}") if session['id_k']
    if session['f'] || !@kontrahent
      @kontrahent=Kontrahent.find(:first, :conditions => "id = #{session['id_k']}") if session['id_k']
    end
    if session['id_w']
     # @wystawca=Wystawca.find(:first, :conditions => "id = #{session['id_w']}")
      @wystawca=WystawcaFakturowany.find(:first, :conditions => "id = #{session['id_w']}")
      if session['f']
        @wystawca = Wystawca.find(session['id_w'])
      end
      @wzor= @wystawca.wzor
      @id_w = session['id_w']
      @ile_f = Towar.find_by_sql("Select max(pozycja) as poz, nr_faktury from fak_kont_suma where nr_faktury like \"%/#{@wzor}%\" and user_id = #{current_user.id} and id_wystawcy = #{@id_w}")
      @ile_f.each do |item|
        @i = item.poz
        @nr = item.nr_faktury
      end
      session['nr_f']= "#{@nr.to_i+1}/#{@wzor}" if !session['edit']
    end
    if params[:nr_faktury] and params[:z_print]
      #reset
      @id_w = params[:id_w]
      Tymczasowa.find_by_sql "Delete from tymczasowa where t_user_id = #{current_user.id} and id_wystawcy =#{@id_w} "
      @nr_faktury=params[:nr_faktury]
      @wynik = Towar.find_by_sql("Select f.id_towaru, f.f_ilosc_towaru, f.nazwa_towaru, f.symbol_towaru,  f.f_ctn, f.pod, f.f_ctb, f.jm from faktury as f where  f.nr_faktury=\"#{@nr_faktury}\" and f.id_wystawcy = #{@id_w}")
      @wynik2 = Towar.find_by_sql("select fks.data_wystawienia, fks.termin, fks.miejsce_w, fks.data_sprzedazy, fks.pozycja, fks.uwagi from fak_kont_suma as fks where nr_faktury=\"#{@nr_faktury}\" and id_wystawcy=#{@id_w}")
      @wynik.each_with_index do |item, index|
        if item.nazwa_towaru.to_s == ""
          @jesli_tylko_towar = Towar.find_by_sql("Select nazwa_towaru, symbol_towaru from towar where id = #{item.id_towaru}")
          @jesli_tylko_towar.each do |item2|
            item.nazwa_towaru = item2.nazwa_towaru
            item.symbol_towaru = item2.symbol_towaru
          end
        end
        Towar.find_by_sql("Insert into tymczasowa(id_t, t_nazwa_towaru, t_symbol_towaru, t_ilosc, t_cena_netto, t_podatek, t_cena_brutto, t_jm, t_ord, t_user_id, id_wystawcy) values(#{item.id_towaru}, \"#{item.nazwa_towaru}\",\"#{item.symbol_towaru}\", #{item.f_ilosc_towaru}, #{item.f_ctn}, #{item.pod}, #{item.f_ctb}, \"#{item.jm}\", #{index},  #{current_user.id}, #{@id_w})")
      end
      @wynik2.each do |item|
        session['data_w'] = item.data_wystawienia
        session['data_s'] = item.data_sprzedazy
        session['termin'] = item.termin
        session['m_w'] = item.miejsce_w
        session['uwagi'] = item.uwagi
        session['edit'] = params[:z_print] if params[:z_print]
        if session['edit']
          session['poz'] = item.pozycja
          session['nr_f'] = @nr_faktury
        end
      end
    end
    licz
    @suma_faktury= display_s(@suma_faktury)
    @sf_text = slownie("#{@suma_faktury}")
    session['m_w'] = params[:m_w] if params[:m_w]
    session['data_w'] = params[:data_w] if params[:data_w]
    session['data_s'] = params[:data_s] if params[:data_s]
    session['termin'] = params[:termin] if params[:termin]
    session['nr_f'] = params[:nazwa]  if params[:nazwa]
    session['uwagi'] = params[:uwagi] if params[:uwagi]
  end

  def licz
    @w_netto = 0
    @w_vat = 0
    @w_brutto = 0
    @p = current_user.id
    @suma_faktury = 0
    @pozycja = {}
    @towar = Towar.find_by_sql("select ty.id, ty.id_t, ty.t_nazwa_towaru as nazwa_towaru, ty.t_jm as t_jm,  ty.t_symbol_towaru as symbol_towaru, ty.t_cena_netto as cena_netto, ty.t_cena_brutto as cena_brutto, ty.t_podatek as podatek, ty.t_ord as t_ord, ty.t_ilosc as t_ilosc_towaru from towar as t, tymczasowa as ty where t.id = ty.id_t and ty.t_user_id=#{@p}")
    @t=Tymczasowa.count_by_sql("select count(id)  from tymczasowa where t_user_id = #{@p}")
    @towar.each_with_index do |item, i|
      @pozycja["index"] = i
      @pozycja["id_#{i}"]=item.id
      @pozycja["id_t_#{i}"] = item.id_t
      @pozycja["nazwa_towaru_#{i}"] = item.nazwa_towaru
      @pozycja["symbol_towaru_#{i}"] = item.symbol_towaru
      @pozycja["jm_#{i}"] = item.t_jm
      @pozycja["t_ilosc_towaru_#{i}"] = item.t_ilosc_towaru
      @pozycja["cena_netto_#{i}"] = item.cena_netto
      @pozycja["podatek_#{i}"] = item.podatek
      @pozycja["t_ord{@p}"] = item.t_ord
      @pozycja["cena_brutto_#{i}"] = item.cena_brutto.to_f
      @pozycja["suma_brutto_#{i}"] = item.cena_brutto.to_f * item.t_ilosc_towaru.to_f
      @suma_faktury+= @pozycja["suma_brutto_#{i}"].to_f
    end
    @podlicz_sume = Tymczasowa.find_by_sql("select t_nazwa_towaru as nazwa_towaru, t_cena_netto as s_cena_netto, t_podatek as podatek, t_cena_brutto as s_cena_brutto,  t_ilosc  as t_ilosc_towaru from tymczasowa where t_user_id = #{@p}")
    @podlicz_sume.each do |item|
      @w_pod = item.podatek
      @w_netto += item.s_cena_netto.to_f * item.t_ilosc_towaru.to_f
      @w_vat += (item.s_cena_brutto.to_f * item.t_ilosc_towaru.to_f)
      @w_brutto += (item.s_cena_brutto.to_f * item.t_ilosc_towaru.to_f)
    end
  end


  def history
    @id_w = params['id_w']
    @zalegle = (FakKontSuma.count(id, :conditions => "stan_faktury=0 and user_id = #{current_user.id} and id_wystawcy=#{@id_w}"))
    #TODO: Czy można przyspieszyć to zapytanie?
    @faktury_wystawione = Towar.find_by_sql("Select fks.rabat, k.nazwa, fks.id_wystawcy, fks.id_kontrahenta, fks.nr_faktury, fks.suma_faktury, fks.data_wystawienia,
    fks.data_sprzedazy, fks.stan_faktury, fks.forma_platnosci, fks.termin from fak_kont_suma as fks, kontrahent as k
    where fks.id_wystawcy = #{@id_w} and fks.user_id = #{current_user.id} and fks.id_kontrahenta = k.id group by fks.nr_faktury order by fks.pozycja DESC")
    @sf = FakKontSuma.sum('suma_faktury', :conditions => "id_wystawcy = #{@id_w} and user_id=#{current_user.id}")
  end

  def dodaj
    @id_w = session['id_w']
    if @id_w.nil?
      redirect_to :action => "new"
      flash[:notice] = "Prosze dodac wystawce przed zalaczeniem towaru"
    else
      @id = params[:id]
      @idp = params[:idp]
      @p = current_user.id
      @pozycja = {}
      @towar = Towar.find(:first, :conditions => "id = #{@id}")
      Tymczasowa.find_by_sql("Insert into tymczasowa(id_t, t_nazwa_towaru, t_symbol_towaru,  t_ilosc, t_cena_netto,  t_podatek, t_cena_brutto, t_user_id, t_jm, id_wystawcy)
       values(#{@towar.id}, \"#{@towar.nazwa_towaru}\", \"#{@towar.symbol_towaru}\",0, #{@towar.cena_netto}, #{@towar.podatek}, #{@towar.cena_brutto}, #{@p}, \"#{@towar.jm}\", #{@id_w})")
      redirect_to :action => "new"
    end
  end

  def licz_sume_brutto
    @p = current_user.id
    i = params[:i]
    @id = params["id"]
    @id_t = params["id_t"]
    if (params["cena_netto#{i}"]!="" && params["cena_netto#{i}"]!~/\,/) || (params["cena_brutto#{i}"]!=""  && params["cena_brutto#{i}"]!~/\,/) \
        && params["podatek#{i}"]!="" && params["ilosc#{i}"]!=""
      @nazwa_towaru = params["nazwa#{i}"]
      @symbol_towaru = params["kod#{i}"]
      @netto = params["cena_netto#{i}"].to_f
      @podatek = params["podatek#{i}"]
      @brutto = params["cena_brutto#{i}"].to_f
      @podatek2 = (@podatek.to_f/100)+1
      if params[:n].present?
        if @podatek2 == 1.0
          @brutto = display_s(@netto.to_f)
        else
          @brutto =  @netto.to_f * @podatek2.to_f
          @brutto = display_s(@brutto.to_f)
        end
      elsif params[:b].present?
        @netto = @brutto.to_f / @podatek2.to_f
        @brutto = display_s(@brutto.to_f)
      end
      @podatek=display_s(@podatek.to_f)
      if params["ilosc#{i}"]
        @ilosc = params["ilosc#{i}"]
        Tymczasowa.find_by_sql("Update tymczasowa set t_nazwa_towaru = \"#{@nazwa_towaru}\", t_symbol_towaru = \"#{@symbol_towaru}\", t_ilosc = #{@ilosc}, t_cena_netto = #{@netto}, t_podatek=#{@podatek}, t_cena_brutto=#{@brutto} where id_t = #{@id_t} and id = #{@id} and t_user_id = #{@p}")
        # render :text => "#{@podatek2}, #{@netto}, #{@brutto} "
        render :text => display_s((@brutto.to_f * @ilosc.to_f))
      else
        Tymczasowa.find_by_sql("Update tymczasowa set t_nazwa_towaru = \"#{@nazwa_towaru}\" , t_symbol_towaru = \"#{@symbol_towaru}\", t_cena_netto = #{@netto}, t_podatek=#{@podatek}, t_cena_brutto=#{@brutto} where id_t = #{@id_t} and id = #{@id} and t_user_id = #{@p}")
        render :text => display_s((@brutto.to_f * @ilosc.to_f))
      end
    else
      if params["cena_netto#{i}"] =~/\,/ || params["cena_brutto#{i}"] =~ /\,/
        render :text => "<font color='red'>Nie dozwolony znak</font>"
      else
        render :text => "Prosze wypełnić pola"
      end
    end
  end

  def remove
    begin
      @id_t = params["id_t"]
      @id = params["id"]
      @id_w = session['id_w']
      @p = current_user.id
      Tymczasowa.find_by_sql("Delete from tymczasowa where id_t = #{@id_t} and id=#{@id} and id_wystawcy = #{@id_w}")
    rescue Exception => e
      flash[:notice] = "<h2><font color='green'>Nie można wykonać operacji! Proszę wybrać wystwcę</font></h2>"
    end
    redirect_to :action => "new"
  end

  def kontrahent
    @id_k = params[:id]
    session['id_k'] = @id_k
    @f = params[:f]
    redirect_to :action => "new", :id_k => @id_k
  end

  def wystawca
    @id_w = params[:id]
    #@id_w = current_user.id
    session['id_w'] = @id_w
    @f = params[:f]
    redirect_to :action => "new", :id_w => @id_w
  end


  def zapisz
    session['nr_f']=session['nr_f'].gsub("."," ") if session['nr_f'] =~ /\./
    if !session['edit'].nil?
      @id_w = session['id_w']
      @nr_faktury = session['nr_f']
      Towar.find_by_sql("DELETE from faktury where nr_faktury like \"#{@nr_faktury}\" and user_id = #{current_user.id} and id_wystawcy=#{@id_w}")
      Towar.find_by_sql("Delete from fak_kont_suma where nr_faktury like \"#{@nr_faktury}\" and user_id = #{current_user.id} and id_wystawcy=#{@id_w}")
    end
    if session['id_w'].nil? || session['id_k'].nil? || session['nr_f'].nil?
      redirect_to :action => "new", :msg => "Wystawca oraz odbiorca muszą zostać wybrani. Proszę sprawdzić czy wzór numeru faktur jest zdefiniowany dla wystawcy."

    elsif Tymczasowa.count_by_sql("Select count(id) from tymczasowa where t_user_id = #{current_user.id}")  == 0
      redirect_to :action => "new", :msg => "Proszę wprowadzić pozycję do faktury"

    elsif  Tymczasowa.count_by_sql("Select count(t_ilosc) from tymczasowa where t_user_id = #{current_user.id} and t_ilosc=0 ") != 0
      redirect_to :action => "new", :msg => "Proszę wpisać ilość towaru dla każdej pozycji"

    else
      @nr_faktury = session['nr_f']
      @id_w = session['id_w']
      @id_k = session['id_k']
      @data_w = params[:data_w]
      @data_s = params[:data_s]
      @uwagi = params[:uwagi]
      @m_w = params[:m_w]
      @termin = params[:termin]
      @rabat = params[:rabat]
      @fp = params[:fakturka]
      @uwagi = params[:uwagi]
      @p = current_user.id
      if params[:oplacona].to_s == "Zapłacona"
        @za = 1
      else
        @za = 0
      end
      licz

      @wystawca = Wystawca.find(@id_w)
      @wf = WystawcaFakturowany.new(@wystawca.attributes)
      WystawcaFakturowany.find_by_nr_faktury_and_user_id(@nr_faktury, current_user.id).delete  if WystawcaFakturowany.find_by_nr_faktury_and_user_id(@nr_faktury, current_user.id)
      @wf.id_w = @wystawca.id
      @wf.nr_faktury = @nr_faktury
      @wf.save!

      @kontrahent = Kontrahent.find(@id_k)
      @kf = KontrahentFakturowany.new(@kontrahent.attributes)
      KontrahentFakturowany.find_by_user_id_and_nr_faktury(current_user.id, @nr_faktury).delete if KontrahentFakturowany.find_by_user_id_and_nr_faktury(current_user.id, @nr_faktury)
      @kf.id_k = @kontrahent.id
      @kf.nr_faktury = @nr_faktury

      @kf.save!

      0.upto(@t.to_i-1 ) do |i, index|
        @pozycja["cena_netto_#{i}"]=@pozycja["cena_netto_#{i}"].length(-1) if @pozycja["cena_netto_#{i}"].last == "."
        @brutto_a_netto=@pozycja["cena_netto_#{i}"].to_f * (@pozycja["podatek_#{i}"].to_f/100)
        @suma_brutto =  (@pozycja["cena_netto_#{i}"].to_f * @pozycja["t_ilosc_towaru_#{i}"].to_f) * (1 + (@pozycja["podatek_#{i}"].to_f / 100))
        Towar.find_by_sql("Insert into faktury(nr_faktury, id_towaru, nazwa_towaru, symbol_towaru,   f_ilosc_towaru, f_ctn, pod, f_wys_pod, f_ctb, f_stb, created_on, updated_on, user_id, jm, poz, id_wystawcy) values(\"#{@nr_faktury}\", \"#{@pozycja["id_t_#{i}"]}\", \"#{@pozycja["nazwa_towaru_#{i}"]}\", \"#{@pozycja["symbol_towaru_#{i}"]}\", \"#{@pozycja["t_ilosc_towaru_#{i}"]}\",\"#{@pozycja["cena_netto_#{i}"]}\", \"#{@pozycja["podatek_#{i}"]}\", \"#{@brutto_a_netto}\" , \"#{@pozycja["cena_brutto_#{i}"]}\", \"#{@suma_brutto}\", \"#{Date.today}\", \"#{Date.today}\", \"#{@p}\", \"#{@pozycja["jm_#{i}"]}\", \"#{i}\", #{@id_w})")
      end
      if params[:poz]
        @i = params[:poz].to_i - 1
      else
        @ile = Towar.find_by_sql("select max(pozycja) as poz from fak_kont_suma where user_id=\"#{current_user.id}\" and id_wystawcy = \"#{@id_w}\"")
        @ile.each do |item|
          @i = item.poz
        end
      end


      Towar.find_by_sql("Insert into fak_kont_suma(nr_faktury, id_wystawcy, id_kontrahenta, suma_faktury, data_wystawienia, data_sprzedazy, termin, stan_faktury, forma_platnosci, miejsce_w, rabat, user_id, pozycja, uwagi)
      values(\"#{@nr_faktury}\", \"#{@id_w}\",  \"#{@id_k}\", \"#{@suma_faktury}\", \"#{@data_w}\", \"#{@data_s}\", \"#{@termin}\", \"#{@za}\", \"#{@fp}\", \"#{@m_w}\", \"#{@rabat}\", \"#{@p}\", #{@i.to_i+1}, \"#{@uwagi}\")")
      #reset
      redirect_to :action => "show", :id=>@nr_faktury, :id_w => @id_w, :id_k => @id_k
    end
  end
  def destroy
    Towar.find_by_sql("delete from faktury where nr_faktury like \"#{params[:id]}\" and id_wystawcy like \"#{params[:id_w]}\"")
    Towar.find_by_sql("delete from fak_kont_suma where nr_faktury like \"#{params[:id]}\" and id_wystawcy like \"#{params[:id_w]}\"")
    redirect_to :action => "history", :id_w => params[:id_w]
  end

  def show
    if params["format"]
      params["id"]=params["id"] +"."+params["format"]
    end
    @skad = params[:skad]
    @suma_faktury = 0
    @s_ptu=0.to_f
    @s_brutto=0.to_f
    @s_netto=0.to_f
    @p = current_user.id
    @id_k = params[:id_k]
    @id_w = params[:id_w]
    @pozycja = {}
    @nr_faktury = params["id"]
    #@t=Towar.count_by_sql("select count(id) from faktury where nr_faktury like \"#{@nr_faktury}\" and user_id=\"#{current_user.id}\" and id_wystawcy=#{@id_w}")
    @pozycja = Towar.find_by_sql("Select f.id as id, fks.rabat, fks.miejsce_w, fks.suma_faktury as suma_faktury, fks.forma_platnosci as fp, fks.termin as termin, fks.uwagi as uwagi,
    f.f_ilosc_towaru as f_ilosc_towaru, f.f_ctn as f_ctn, f.pod as podatek, f.f_wys_pod as f_wys_pod, f.f_ctb as f_ctb, f.f_stb as f_stb, f.id_towaru as id_towaru,
    f.jm as jm, f.nazwa_towaru as nazwa_towaru, f.symbol_towaru as symbol_towaru, fks.data_wystawienia as data_w,  fks.data_sprzedazy as data_s  from faktury as f,
    fak_kont_suma as fks   where fks.nr_faktury = \"#{@nr_faktury}\" and f.nr_faktury = fks.nr_faktury  and fks.user_id = #{current_user.id}  group by f.id")
    @pozycja.each do |item|
      @data_w = item.data_w
      @data_s = item.data_s
      @termin = item.termin
      @fp = item.fp
      @rabat = item.rabat
      @suma_faktury = item.suma_faktury
      @m_w = item.miejsce_w
      @uwagi = item.uwagi
    end
    @kf = KontrahentFakturowany.find_by_id_k_and_nr_faktury(@id_k, @nr_faktury)
    if !@kf
      @kf = Kontrahent.find(@id_k)
    end
    @id_wf = @wf.id if @wf = WystawcaFakturowany.find_by_id_w_and_nr_faktury(@id_w, @nr_faktury)
    if !@wf
      @id_wf = @wf.id if @wf = WystawcaFakturowany.find_by_id_w_and_nr_faktury(@id_w, '')
    elsif !@wf
      @wf = Wystawca.find(@id_w)
    end
    @podlicz_sume = Towar.find_by_sql("select f.pod as pod, sum(f.f_stb) as suma_faktury, sum(f.f_ctn * f.f_ilosc_towaru) as stn, sum(f.f_ctb * f.f_ilosc_towaru) as stb,
    sum(f.f_wys_pod * f.f_ilosc_towaru) as s_pod from faktury as f where f.nr_faktury like \"#{@nr_faktury}\" and user_id = \"#{current_user.id}\"  group by f.pod")
    @podlicz_sume.each do |item|
      @s_netto +=item.stn.to_f
      @s_brutto +=item.stn.to_f + item.s_pod.to_f
      @s_ptu += item.s_pod.to_f

    end
    if @rabat.to_i > 0
      @suma_rabat = (@suma_faktury.to_f * ((-@rabat.to_f/100) + 1))
      @suma_rabat = display_s(@suma_rabat)
      @sf_text = slownie("#{@suma_rabat}")
    else
      @suma_faktury= display_s(@suma_faktury)
      @sf_text = slownie("#{@suma_faktury}")
    end
  end

  def display_s(val)
    sprintf("%0.2f", val)
  end

  def pay
    Towar.find_by_sql("Update fak_kont_suma set stan_faktury=1 where nr_faktury=\"#{params[:id]}\" ")
    redirect_to :action => "history", :id_w => params["id_w"]
    flash[:notice]="Faktura nr: #{params[:id]} została opłacona"
  end

  def rabat
    @rabat = params["rabat"].to_s
    @p = current_user.id
    @podlicz_sume = Tymczasowa.find_by_sql("select sum(t.t_cena_netto * t.t_ilosc) as stn, t_podatek as podatek from tymczasowa as t where t.t_user_id=#{@p}")
    @podlicz_sume.each do |item|
      @s_ = ((item.stn.to_f * ((-@rabat.to_f/100)+1)) * ((item.podatek.to_f/100)+1))
    end
    @porabacie = (@s_.to_f) #* ((-@rabat.to_f/100)+1))
    render :text => "Kwota po rabacie: #{display_s(@porabacie)} zł"
  end
  def termin
    session['termin'] = params[:termin]
    session['data_w'] = params[:data_w]
    session['data_s'] = params[:data_s]
    session['m_w'] = params[:m_w]
    @nazwa = params[:nazwa]
    session['nr_f'] = params[:nazwa]
    @ile_f = Towar.count_by_sql("Select count(id) from fak_kont_suma where nr_faktury like \"#{@nazwa}\" and user_id = #{current_user.id}")
    if @ile_f != 0
      flash[:msg]="Faktura o podanej nazwie juz istnieje. Prosze wprowadzic nowa nazwe"
    else
      session['edit']='true'
      render :nothing => true
    end

  end
  def reset
    session['edit'] = nil
    session['m_w']="Nowy Sącz"
    session['data_w']=nil
    session['data_s']=nil
    session['termin']=nil
    session['id_k'] = nil
    session['id_w'] = nil
    session['f'] = nil
    session['idp'] = nil
    session['nr_f'] = nil
    session['poz']=nil
    session['uwagi']=nil
    @p = current_user.id
    Tymczasowa.find_by_sql "Delete from tymczasowa where t_user_id = #{@p}"
    redirect_to :action=>'new' if params[:id].to_s == "f"
  end

  def firma
    @ile_firm = Wystawca.count_by_sql("select count(id) from wystawca where user_id =#{current_user.id}");
    @wystawca = Wystawca.find(:all, :conditions=>"user_id = #{current_user.id}")
  end

  def jm
    @i = params[:i]
    @jm = params["jm_#{@i}"]
    @id = params[:id]
    @id_t = params[:id_t]
    #Towar.find_by_sql("Update towar set jm = \"#{@jm}\" where id = \"#{@id}\" ")
    Tymczasowa.update_all("t_jm = \"#{@jm}\"", "id = \"#{@id}\"")
    render :nothing => true
  end

  def wzor
    @wzor = params[:wzor]
    Towar.find_by_sql("Update wzor set \"#{@wzor}\" where #{current_user.id}")
  end

  def uwagi
    session['uwagi']=params[:uwagi]
    return 0
  end

  def check_for_comma(value)
    return value.gsub(",",".")
  end

  def podlicz
    if params[:from].present? && params[:to].present? && params[:id_w].present?
      from = params[:from].to_date
      to = params[:to].to_date
      id_w = params[:id_w].to_i
      @suma = Wystawca.find_by_sql(["select SUM(f_ilosc_towaru* f_ctn) AS netto,
                                SUM(f_ilosc_towaru * f_ctb) AS brutto,
                                pod
                                FROM faktury WHERE created_on >= ?
                                AND created_on <= ?
                                AND id_wystawcy = ? GROUP BY pod;", from, to, id_w])

      @suma
    end
  end

end

