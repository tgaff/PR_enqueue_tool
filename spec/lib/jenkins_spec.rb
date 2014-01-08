require 'spec_helper'
require "#{Rails.root}/lib/jenkins"

describe Jenkins do

  subject(:jenkins) { Jenkins }
  describe '.post_build' do
    let(:url) { 'http://example.com' }
    let(:pr) { 23 }
    let(:http_response) { double() }
    before do
      Curl::Easy.stub(:http_post) { http_response }
      http_response.stub(:body_str) { ' ' }
      http_response.stub(:response_code) { 302 }
    end

    it 'posts to the specified SERVER' do
      expect(Curl::Easy).to receive(:http_post).with(url, anything())
      jenkins.post_build(url, pr)
    end

    it 'ignores non-errors' do
      expect(jenkins).to_not receive(:handle_post_error)
      jenkins.post_build(url, pr)
    end

    it 'does something with post errors' do
      http_response.stub(:response_code) { 404 }
      expect(jenkins).to receive(:handle_post_error)
      jenkins.post_build(url, pr)
    end

    it 'does something with curl exceptions' do
      Curl::Easy.stub(:http_post) { raise 'ye gads' }
      expect(jenkins).to receive(:handle_post_error)
      jenkins.post_build(url, pr)
    end

  end

  describe '.jenkins_jsonify' do
    subject(:json) { Jenkins.jenkins_jsonify( { taskfile: 'some_file', task: 3, 'jobParameters' => 'jobArgs'} )}
    let(:n) { '"name":' }
    let(:v) { '"value":' }
    let(:json_fixture) do
      <<-JSON
        {\"parameter\":[
          {\"name\":\"taskfile\",\"value":\"some_file\"},
          {#{n}\"task\",#{v}\"3\"},
          {#{n}\"jobParameters\",#{v}\"jobArgs\"}
          ]
        }
        JSON
    end

    it 'converts a hash into appropriate json with strings' do
      json.should eq json_fixture.gsub(/\s+/,'')
    end
  end

  describe '.build_pr' do
    let(:url) { 'http://foofarmers.com' }
    let(:path) { 'bar' }

    before do
      allow(jenkins).to receive(:server_url).and_return( url )
      allow(jenkins).to receive(:build_path) { path }
      allow(jenkins).to receive(:sleep).and_return(true)
    end

    it 'sends a constructed URL to post_build' do
      expect(Jenkins).to receive(:post_build).with(url + '/' + path, 22 )

      jenkins.build_pr(22)
    end
  end
end
