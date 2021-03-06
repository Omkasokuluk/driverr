class DriversController < ApplicationController
	def index
		if params[:search].present?
			@driver = Driver.find_by(pin: params[:pin]) if params[:pin].present?
			@drivers = Driver.search(
	        params[:search],
	        fields: %i[pin passport_number name last_name passport_series],
	        page: params[:page],
	        per_page: 2, misspellings: {fields: %i[pin passport_number name last_name passport_series]},
		    match: :word_start)
	    else
			@drivers=Driver.all
	    end
	end

	def new
    	@driver = Driver.new
  	end

	def create
		@driver = Driver.new(create_params)  
		if @driver.save
			redirect_to root_path
		else
			render :new
		end
	end

	def show
		@driver = Driver.find(params[:id])
		@comments = Comment.all
	end

	def comment_new
		@comment = Comment.new
		@driver=Driver.find(params[:id])
		@comment.driver_id = @driver.id
	end

	def comment_create
		@user = current_user
		@comment = Comment.new(comment_create_params)
		if @comment.save
			redirect_to drivers_show_url(@comment.driver)
		else
			render :comment_new
		end
	end

	private
	def create_params
    	params.require(:driver).permit(:name, :last_name, :pin, :passport_number, :passport_series, :image)
  	end
  	def comment_create_params
    	params.require(:comment).permit(:short_desc, :long_desc, :driver_id, :user_id)
  	end

end