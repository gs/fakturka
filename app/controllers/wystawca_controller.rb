require 'will_paginate'

class WystawcaController < ApplicationController
	before_filter :login_required

    verify :method => :post, :only => [ :destroy, :create, :update ],
        :redirect_to => { :action => :index }

    def index
       session['f'] = params[:f] if params[:f]
        @wystawca =  Wystawca.paginate(:page => params[:page], :per_page => '100', :conditions =>"user_id = #{current_user.id}" ,:order=> 'nazwa ASC')
        #redirect_to :action => "list"
    end


    def list
	#@wystawca = will_paginate :wystawca, :per_page => 100
        @wystawca =  Wystawca.paginate(:page => params[:page], :per_page => '100', :conditions => "user_id = #{current_user.id}", :order=> 'nazwa ASC')
    end

    def show
        @wystawca = Wystawca.find(params[:id])
    end
  

    def edit
        @wystawca=Wystawca.find(params[:id])
    end

    def new
        @wystawca=Wystawca.new
    end

    def create
        @wystawca = Wystawca.new(params[:wystawca])
        @wystawca.user_id = current_user.id
        if @wystawca.save
            flash[:notice] = "Nowy wystawca dodany"
            redirect_to :action => "index"
        else
            render :action=> 'new'
        end
    end

    def change
        @wystawca = Wystawca.find(params[:id])
        if @wystawca.update_attributes(params[:wystawca])
            flash[:notice]="Dane wystawcy zmienione"
            redirect_to :action => "index"
        end

    end

    def destroy
        Wystawca.find(params[:id]).destroy
        flash[:notice] = "usunieto"
        redirect_to :action => "index"
    end
     def delete
        Wystawca.find(params[:id]).destroy
        flash[:notice] = "usunieto"
        redirect_to :action => "index"
    end
    

end
