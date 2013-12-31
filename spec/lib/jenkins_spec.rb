require 'spec_helper'
require "#{Rails.root}/lib/jenkins"

describe Jenkins do
  include Jenkins

  describe '.post_build' do
    let(:url) { 'http://example.com' }
    let(:pr) { 23 }
    let(:http_response) { double() }
    before do
      Curl.stub(:post) { http_response }
      http_response.stub(:body_str) { ' ' }
      http_response.stub(:response_code) { 200 }
    end

    it 'posts to the specified SERVER' do
      expect(Curl).to receive(:post).with(url, anything())
      post_build(url, pr)
    end

    it 'ignores non-errors' do
      expect(self).to_not receive(:handle_post_error)
      post_build(url, pr)
    end

    it 'does something with errors' do
      http_response.stub(:response_code) { 404 }
      expect(self).to receive(:handle_post_error)
      post_build(url, pr)
    end


  end

  describe '.build_pr' do
    let(:url) { 'http://foofarmers.com' }
    let(:path) { 'bar' }

    before do
      allow(self).to receive(:server_url).and_return( url )
      allow(self).to receive(:build_path) { path }
      double(:post_build)
    end

    it 'sends a constructed URL to post_build' do
      expect(self).to receive(:post_build).with(url + '/' + path, 22 )

      build_pr(22)
    end
  end
end
