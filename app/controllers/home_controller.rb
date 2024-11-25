class HomeController < ApplicationController
    before_action :authenticate_user!, except: [:index]
    def index
       @title_text='Hello Word!'
       @subtitle_text='I am Learning rails'
        
       
    end
    
    #Ex:- add_index("admin_users", "username")

end