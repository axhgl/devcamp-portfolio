class PortfoliosController < ApplicationController
	before_action :find_portfolio_item, only: [:show, :edit, :update, :destroy]
	layout 'portfolio'
    
    access all: [:show, :index, :index], user: {except: [:destroy, :new, :create, :update, :edit, :sort]}, site_admin: :all

	def index
		@portfolio_items = Portfolio.by_position
	end

	def angular
		@angular_portfolio_items = Portfolio.angular
	end

	def new
		@portfolio_item = Portfolio.new
	end

	def show
	end

  def create
    @portfolio_item= Portfolio.new(portfolio_params)

    respond_to do |format|
      if @portfolio_item.save
        format.html { redirect_to :portfolios, notice: 'Portfolio was successfully created.' }
        format.json { render :show, status: :created, location: @portfolio_item}
      else
        format.html { render :new }
        format.json { render json: @portfolio_item.errors, status: :unprocessable_entity }
      end
    end
  end

	def edit
	end

	def update
    respond_to do |format|
      if @portfolio_item.update(portfolio_params)
        format.html { redirect_to :portfolios, notice: 'Blog was successfully updated.' }
        format.json { render :show, status: :ok, location: @portfolio_item}
      else
        format.html { render :edit }
        format.json { render json: @portfolio_item.errors, status: :unprocessable_entity }
      end
    end
	end

	def destroy
        @portfolio_item.destroy
        respond_to do |format|
          format.html { redirect_to portfolios_url, notice: 'Portfolio was successfully destroyed.' }
        end
	end

    def sort
        params[:order].each do |key, value|
            Portfolio.find(value[:id]).update(position: value[:position])
        end

        render nothing: true
    end

	private
	
	def find_portfolio_item
		@portfolio_item = Portfolio.find(params[:id])
	end

	def portfolio_params
		params.require(:portfolio).permit(:title, 
																			:subtitle, 
																			:body, 
                                                                            :main_image,
                                                                            :thumb_image,
																			technologies_attributes: [:name, :id, :_destroy]
																		)
	end
end
