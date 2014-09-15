require 'spec_helper'

describe Spree::Admin::MenuItemsController do
  stub_authorization!

  let!(:menu_item) { create(:menu_item) }

  let(:index_path) { spree.admin_menu_items_path }

  let(:valid_item)   { { name: Faker::Lorem.word } }
  let(:invalid_item) { { name: '' } }

  context '#index' do
    it 'loads `index` template' do
      spree_get :index
      expect(response).to render_template(:index)
    end
  end

  context '#edit' do
    it 'loads `edit` template' do
      spree_get :edit, id: menu_item.id
      expect(response).to render_template(:edit)
    end
  end

  context '#update' do
    context 'fails with invalid values' do
      it 'then renders `edit` template' do
        spree_post :update, id: menu_item.id, menu_item: invalid_item
        expect(response).to render_template(:edit)
      end
    end

    it 'updates menu item' do
      spree_post :update, id: menu_item.id, menu_item: valid_item
      resource_desc = menu_item.class.model_name.human
      if menu_item.respond_to?(:name) && menu_item.name.present?
        resource_desc += " \"#{valid_item[:name]}\""
      end
      expect(flash[:success]).to(
        eq Spree.t(:successfully_updated, resource: resource_desc)
      )
      expect(response).to redirect_to(index_path)
    end
  end
end