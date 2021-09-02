class UserStocksController < ApplicationController
    def create
        stock = Stock.check_db(params[:ticker])
        if stock.blank?
            stock = Stock.new_lookup(params[:ticker])
            stock.save
        end
        @user_stock = UserStock.create(user: current_user, stock: stock)
        flash[:notice] = "Stock #{stock.name} was successfully added to your portfolio"
        redirect_to my_portfolio_path
    end

    # def destroy
    #     stock = Stock.find(params[:id])
    #     user_stock = UserStock.where(user_id: current_user.id, stock_id: stock.id).first
    #     user_stock.destroy
    #     flash[:notice] = "#{stock.ticker} was successfully removed"
    #     redirect_to my_portfolio_path
    # end

    def destroy
        @user_stock.destroy(@user_stock.id)
        respond_to do |format|
          format.html { redirect_to my_portfolio_path, notice: 'Stock was successfully removed from portfolio.' }
          format.json { head :no_content }
        end
      end
     
     private
        # Use callbacks to share common setup or constraints between actions.
        def set_user_stock
          @user_stock = UserStock.where(stock_id: params[:id], user: current_user).first
        end
end
