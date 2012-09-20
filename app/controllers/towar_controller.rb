
require 'will_paginate'

class TowarController < ApplicationController
	before_filter :login_required

  def index
    redirect_to :action => "list"
  end
  def list
    session['idp'] = params['idp'] if params['idp']
    @p = current_user.id

    @towar = Towar.all(:conditions => "user_id", :order => "nazwa_towaru ASC")
  end

  def new
    @towar = Towar.new
  end

  def create
    @towar = Towar.new(params[:towar])
    licz_brutto(@towar.cena_netto, @towar.podatek)
    @towar.cena_brutto=@wynik
    @towar.user_id = current_user.id
    if @towar.save
      flash[:notice]="Towar dodany"
      redirect_to :action => "list"
    end
  end

  def show
    @towar = Towar.find(params[:id])
  end

  def edit
    @towar = Towar.find(params[:id])
  end

  def update
    @towar = Towar.find(params[:id])
    licz_brutto(@towar.cena_netto, @towar.podatek)
    @towar.cena_brutto=@wynik
    @towar.user_id = current_user.id
    params[:towar][:cena_netto] = check_for_comma(params[:towar][:cena_netto])
    if @towar.update_attributes(params[:towar])
      flash[:notice] = "Towar został zmieniony"
      redirect_to :action => "list"
    end
  end

  def destroy
    Towar.find(params[:id]).destroy
    flash[:notice] = "towar został usunięty"
    redirect_to :action => "list"
  end

  def licz_brutto(cena_netto=nil, podatek=nil)
    @id = params[:id]
    if @id
      @towar = Towar.find(params[:id])
      @podatek = params["towar"]["podatek"].to_f
      if params["towar"]["cena_netto"] =~ /\,/
        @cena_netto = check_for_comma(params["towar"]["cena_netto"])
      else
        @cena_netto = params[:towar][:cena_netto]
      end
    else
      @towar = Towar.new(params[:towar])
      if @towar.cena_netto =~ /\,/
        @cena_netto= check_for_comma(@towar.cena_netto)
      else
          @cena_netto = @towar.cena_netto 
      end
      @podatek = @towar.podatek.to_f

    end

    if @podatek > 0
      @cena_netto = @cena_netto.to_f
      @wynik = ((@podatek/100) + 1) * @cena_netto
    else
      @wynik = @cena_netto
    end
    @wynik = display_s(@wynik)
    #return @wynik
    # render :text=> "<b>#{@wynik}</b>"
  end
  def display_s(val)
    sprintf("%0.2f", val)
  end

  def check_for_comma(value)
    return value.gsub(",",".")
  end

  def search_for_item
    if is_there?
    	@towar = params["nt"]
    	@towary = Towar.find(:all, :conditions => ["(nazwa_towaru like ? or opis_towaru like ?)",  @towar + "%",'%' + @towar + "%"])  	end
  end

  def is_there?
    !params[:nt].empty?
  end

end

