class ReviewsController < ApplicationController
before_filter :authenticate_user, :only => [:home, :profile, :setting, :new]
    def index
      @reviews = Review.all
      @users = User.all
      response = HTTParty.get("https://newsapi.org/v1/articles?source=associated-press&sortBy=top&apiKey=#{ENV['news']}", {format: :json})
      @data = response['articles'][0]
      #walmart_api
      response = HTTParty.get("http://api.walmartlabs.com/v1/reviews/33093101?apiKey=#{ENV['walmart']}", {format: :json})
      @walm = response['reviews']
      # yelp
      # params = {term: 'starbucks'}
      # res = Yelp.client.search('New York', params)
      # @yelp = res.businesses[0].snippet_text
      res = Yelp.client.business('republic-new-york')
      @yelp = res.business.snippet_text
      #twitter
      @tweet = $twitter.user_timeline("realdonaldtrump", count: 10)
    end

    def new
      @reivew = Review.new
    end

    def create
        title = user_params[:title]
        content = user_params[:content]
        review_link = user_params[:review_link]
      @review = Review.create(
        title: title,
        content: content,
        review_link: review_link,
        user_id: session[:user_id])
      # @review.save

      redirect_to "/reviews"
    end

    def update
      review = params['review']
      Review.update(params[:id],
              title: review[:title],
              content: review[:content],
              user_id: session[:user_id]
              )
  redirect_to "/home"
end



    def destroy
      Review.destroy(params[:id])
      redirect_to(:back)
    end

    private
    def user_params
      params.require(:review).permit(:title, :content, :review_link)
    end

end
