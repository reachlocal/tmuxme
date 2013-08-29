require 'spec_helper'

describe PublicKeysController do
  context "when user is NOT logged in" do
    before do
      allow(controller).to receive(:current_user)
    end

    it "redirects to the login path" do
      get :index
      expect(response).to redirect_to(new_session_path)
    end
  end

  describe "GET index" do
    context "when user is logged in" do
      let(:current_user_mock) { double('current user') }

      before do
        allow(controller).to receive(:current_user).and_return(current_user_mock)
      end

      it "gets all the users public keys" do
        expect(current_user_mock).to receive(:public_keys)
        get :index
      end

      it "assigns the public keys" do
        public_keys_stub = double('public keys')
        allow(current_user_mock).to receive(:public_keys).and_return(public_keys_stub)
        get :index
        expect(assigns(:public_keys)).to eq(public_keys_stub)
      end

      it "renders the index template" do
        allow(current_user_mock).to receive(:public_keys)
        get :index
        expect(response).to render_template('index')
      end
    end

  end

  describe "GET new" do
    context "when user is logged in" do
      let(:current_user_mock) { double('current user') }

      before do
        allow(controller).to receive(:current_user).and_return(current_user_mock)
      end

      it "assigns a new public key" do
        public_key_stub = double('public key')
        allow(PublicKey).to receive(:new).and_return(public_key_stub)
        get :new
        expect(assigns(:public_key)).to eq(public_key_stub)
      end

      it "renders the new template" do
        get :new
        expect(response).to render_template('new')
      end
    end
  end

  describe "POST create" do
    context "when user is logged in" do
      let(:current_user_mock) { double('current user') }

      before do
        allow(controller).to receive(:current_user).and_return(current_user_mock)
      end

      it "creates a public key associated with the logged in user" do
        public_keys_mock = double('public keys arel obj')
        allow(current_user_mock).to receive(:public_keys).and_return(public_keys_mock)
        expect(public_keys_mock).to receive(:create!).with('name' => 'my key blue', 'value' => 'my key blues value')
        post :create, public_key: { name: 'my key blue', value: 'my key blues value' }
      end

      it "redirects to the list public keys page" do
        public_keys_mock = double('public keys arel obj').as_null_object
        allow(current_user_mock).to receive(:public_keys).and_return(public_keys_mock)
        post :create, public_key: { name: 'my key blue', value: 'my key blues value' }
        expect(response).to redirect_to(public_keys_path)
      end
    end
  end
end
