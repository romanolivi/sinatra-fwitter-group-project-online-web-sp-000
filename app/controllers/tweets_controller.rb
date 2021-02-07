class TweetsController < ApplicationController
  
    get "/tweets" do 
      if session[:user_id]
        @tweets = Tweet.all 
        erb :"/tweets/tweets"
      else 
        redirect "/login"
      end
    end
    
    get "/tweets/new" do 
      if logged_in? 
        erb :"/tweets/new"
      else 
        redirect to "/login"
      end
    end
    
    post "/tweets" do 
      # binding.pry
      if !params[:content].empty?
        @new_tweet = Tweet.create(content: params[:content])
        @new_tweet.user = current_user 
        @new_tweet.save 
        redirect to "/tweets/#{@new_tweet.id}"
      else 
        redirect to "/tweets/new"
      end
    end
    
    get "/tweets/:id" do 
      if logged_in? 
        @tweet = Tweet.find(params[:id])
        erb :"/tweets/show_tweet"
      else 
        redirect to "/login"
      end
    end
  
    get '/tweets/:id/edit' do
        if logged_in?
          @tweet = Tweet.find_by_id(params[:id])
          if @tweet && @tweet.user == current_user
            erb :'tweets/edit_tweet'
          else
            redirect to '/tweets'
          end
        else
          redirect to '/login'
        end
    end
    
    
    
    patch "/tweets/:id" do 
      @tweet = Tweet.find(params[:id])
      if params[:content].empty?
        redirect to "/tweets/#{@tweet.id}/edit"
      elsif !params[:content].empty?
        @tweet.update(content: params[:content])
        @tweet.save 
        redirect to "/tweets/#{@tweet.id}"
      elsif !logged_in?
        redirect "/login"
      end
    end
      
    delete "/tweets/:id" do 
      @tweet = Tweet.find(params[:id])
      if @tweet.user == current_user
        @tweet.delete
        redirect to "/tweets"
      else 
        redirect "/tweets/#{@tweet.id}"
      end
    end
  
      
end