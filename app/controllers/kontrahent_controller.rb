require 'will_paginate'

class KontrahentController < ApplicationController
before_filter :login_required

    verify :method => :post, :only => [ :destroy, :create, :update ],
        :redirect_to => { :action => :index }

    def index
      session_enabled?

      session['f'] = params[:f] if params[:f]
        @kontrahent =  Kontrahent.paginate(:page => params[:page], :per_page => '100', :conditions => "user_id = #{current_user.id}", :order=> 'nazwa ASC')
        #redirect_to :action => "list"
    end


    def list
	#@kontrahent = will_paginate :kontrahent, :per_page => 100
        @kontrahent =  Kontrahent.paginate(:page => params[:page], :per_page => '100', :conditions => "user_id =#{current_user.id}", :order=> 'nazwa ASC')
    end

    def show
        @kontrahent = Kontrahent.find(params[:id])
    end

    def edit
        @kontrahent=Kontrahent.find(params[:id])
    end

    def new
        @kontrahent=Kontrahent.new
    end

    def create
        @kontrahent = Kontrahent.new(params[:kontrahent])
        @kontrahent.user_id = current_user.id
        if @kontrahent.save
            flash[:notice] = "Nowy odbiorca dodany"
            redirect_to :action => "index"
        else
            render :action=> 'new'
        end
    end

    def change
        @kontrahent = Kontrahent.find(params[:id])
        @kontrahent.user_id = current_user.id
        if @kontrahent.update_attributes(params[:kontrahent])
            flash[:notice]="Dane odbiorcy zmienione"
            redirect_to :action => "index"
        end

    end

    def destroy
        Kontrahent.find(params[:id]).destroy
        flash[:notice] = "usunieto"
        redirect_to :action => "index"
    end
     def delete
        Kontrahent.find(params[:id]).destroy
        flash[:notice] = "usunieto"
        redirect_to :action => "index"
    end

    def szukaj_kontrahenta
      if !params[:kont].empty?
        k = params[:kont]
        @wyszukani_konrahenci = Kontrahent.find(:all, :conditions => [("nazwa like ? or nip like ?"), '%' + k + '%', '%' + k + '%'])
      end
   end

end

