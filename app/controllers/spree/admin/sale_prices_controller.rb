module Spree
  module Admin
    class SalePricesController < ResourceController
      before_action :load_product
      before_action :load_sale_price, only: [:edit, :update, :destroy]

      respond_to :js, :html

      def index
        @sale_prices = @product.sale_prices
      end

      def create
        if @product.create_sale(sale_price_params)
          flash[:success] = Spree.t(:sale_price_successfully_created)
          redirect_to admin_product_sale_prices_path(@product)
        else
          flash[:error] = Spree.t(:error_on_create)
          render :new
        end
      end

      def update
        if @sale_price.update(sale_price_params)
          flash.now[:success] = Spree.t(:sale_price_successfully_updated)
        else
          flash.now[:error] = Spree.t(:error_on_update)
        end

        redirect_to admin_product_sale_prices_path(@product)
      end

      def stop
        if @product.stop_sale
          flash[:success] = Spree.t(:sale_price_stopped)

          respond_with(@product) do |format|
            format.html { redirect_to admin_product_sale_prices_path(@product) }
            format.js { redirect_to admin_product_sale_prices_path(@product) }
          end
        end
      end

      def enable
        if @product.enable_sale
          flash[:success] = Spree.t(:sale_price_enabled)

          respond_with(@product) do |format|
            format.html { redirect_to admin_product_sale_prices_path(@product) }
            format.js { redirect_to admin_product_sale_prices_path(@product) }
          end
        end
      end

      private

      def sale_price_params
        params.require(:sale_price).permit(permitted_sale_price_attributes)
      end

      def permitted_sale_price_attributes
        [ :id, :value, :currency, :start_at, :end_at, :enabled, :variant_id ]
      end

      def load_product
        @product ||= Spree::Product.friendly.find(params[:product_id])
        redirect_to request.referer unless @product.present?
      end

      def load_sale_price
        @sale_price ||= Spree::SalePrice.find(params[:id])
      end
    end
  end
end