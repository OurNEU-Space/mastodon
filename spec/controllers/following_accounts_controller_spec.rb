# frozen_string_literal: true

require 'rails_helper'

describe FollowingAccountsController do
  render_views

  let(:alice) { Fabricate(:account) }
  let(:followee0) { Fabricate(:account) }
  let(:followee1) { Fabricate(:account) }

  describe 'GET #index' do
    let!(:follow0) { alice.follow!(followee0) }
    let!(:follow1) { alice.follow!(followee1) }

    context 'when format is html' do
      subject(:response) { get :index, params: { account_username: alice.username, format: :html } }

      context 'when account is permanently suspended' do
        before do
          alice.suspend!
          alice.deletion_request.destroy
        end

        it 'returns http gone' do
          expect(response).to have_http_status(410)
        end
      end

      context 'when account is temporarily suspended' do
        before do
          alice.suspend!
        end

        it 'returns http forbidden' do
          expect(response).to have_http_status(403)
        end
      end
    end

    context 'when format is json' do
      subject(:response) { get :index, params: { account_username: alice.username, page: page, format: :json } }

      subject(:body) { response.parsed_body }

      context 'with page' do
        let(:page) { 1 }

        it 'returns followers' do
          expect(response).to have_http_status(200)
          expect(body['totalItems']).to eq 2
          expect(body['partOf']).to be_present
        end

        context 'when account is permanently suspended' do
          before do
            alice.suspend!
            alice.deletion_request.destroy
          end

          it 'returns http gone' do
            expect(response).to have_http_status(410)
          end
        end

        context 'when account is temporarily suspended' do
          before do
            alice.suspend!
          end

          it 'returns http forbidden' do
            expect(response).to have_http_status(403)
          end
        end
      end

      context 'without page' do
        let(:page) { nil }

        it 'returns followers' do
          expect(response).to have_http_status(200)
          expect(body['totalItems']).to eq 2
          expect(body['partOf']).to be_blank
        end

        context 'when account hides their network' do
          before do
            alice.update(hide_collections: true)
          end

          it 'returns followers count' do
            expect(body['totalItems']).to eq 2
          end

          it 'does not return items' do
            expect(body['items']).to be_blank
            expect(body['orderedItems']).to be_blank
            expect(body['first']).to be_blank
            expect(body['last']).to be_blank
          end
        end

        context 'when account is permanently suspended' do
          before do
            alice.suspend!
            alice.deletion_request.destroy
          end

          it 'returns http gone' do
            expect(response).to have_http_status(410)
          end
        end

        context 'when account is temporarily suspended' do
          before do
            alice.suspend!
          end

          it 'returns http forbidden' do
            expect(response).to have_http_status(403)
          end
        end
      end
    end
  end
end
