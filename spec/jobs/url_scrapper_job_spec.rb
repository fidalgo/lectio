require 'rails_helper'

RSpec.describe UrlScrapperJob, type: :job do
  describe '#perform' do
    include ActiveJob::TestHelper
    subject { UrlScrapperJob.new }
    let(:url) { 'http://www.example.com' }
    let(:html_header) { { 'Content-Type' => 'text/html' } }
    let(:title_html_raw) do
      '!DOCTYPE html>
            <html><head>
            <title>Awesome page title</title>
            <head><html>'
    end

    it 'enqueues the job' do
      expect do
        link = create(:link, title: nil)
        expect(link.title).to be nil
        UrlScrapperJob.perform_later link.id
      end.to change { enqueued_jobs.size }.by 1
    end

    it 'gets the longest description' do
      html = '!DOCTYPE html>
        <html><head>
        <meta name="description" content="" />
        <meta property="og:description" content="This is the longest." />
        <meta name="twitter:description" content="Twitter description." />
        <head><html>'

      stub_request(:head, url)
        .to_return(status: 200, body: '', headers:  html_header)
      stub_request(:get, url)
        .to_return(status: 200, body: html, headers: html_header)
      link = create(:link, url: url)
      UrlScrapperJob.perform_now link.id
      link.reload
      expect(link.description).to match(/longest/)
    end

    it 'returns nil on empty description' do
      html = '!DOCTYPE html>
        <html><head>
        <meta name="description" content="" />
        <head><html>'
      stub_request(:head, url)
        .to_return(status: 200, body: '', headers: html_header)
      stub_request(:get, url)
        .to_return(status: 200, body: html, headers: html_header)

      link = create(:link, url: url)
      UrlScrapperJob.perform_now link.id
      link.reload
      expect(link.description).to be_nil
    end

    it 'gets the page title' do
      stub_request(:head, url)
        .to_return(status: 200, body: '', headers: html_header)

      stub_request(:get, url)
        .to_return(status: 200, body: title_html_raw, headers: html_header)

      link = create(:link, url: url)
      UrlScrapperJob.perform_now link.id
      link.reload
      expect(link.title).to match(/page title/)
    end

    it 'saves the filename when the link is a file' do
      filename = 'file.pdf'
      file_url = "#{url}/#{filename}"
      stub_request(:head, file_url)
        .to_return(status: 200, body: '',
                   headers: { 'Content-Type' => 'application/pdf' })

      link = create(:link, url: file_url)
      UrlScrapperJob.perform_now link.id
      link.reload
      expect(link.title).to eq(filename)
    end

    it 'follows the redirects using relative URL' do
      link = create(:link, url: url)
      path = '/welcome.html'
      stub_request(:head, url).to_return(status: 302, body: '',
                                         headers: { 'Location' => path })
      redirect_url = "#{url}#{path}"
      stub_request(:head, redirect_url).to_return(status: 200, body: '',
                                                  headers: html_header)
      stub_request(:get, redirect_url).to_return(status: 200, body: title_html_raw,
                                                 headers: html_header)
      UrlScrapperJob.perform_now link.id
      link.reload
      expect(link.title).to match(/page title/)
    end

    it 'follows the redirects using absolute URL' do
      link = create(:link, url: url)
      redirect_url = "#{url}/welcome.html"
      stub_request(:head, url).to_return(status: 302, body: '',
                                         headers: { 'Location' => redirect_url })
      stub_request(:head, redirect_url).to_return(status: 200, body: '',
                                                  headers: html_header)
      stub_request(:get, redirect_url).to_return(status: 200, body: title_html_raw,
                                                 headers: html_header)
      UrlScrapperJob.perform_now link.id
      link.reload
      expect(link.title).to match(/page title/)
    end

    it 'raises and error when exceeds the redirections limit' do
      link = create(:link, url: url)
      stub_request(:head, url).to_return(status: 302, body: '',
                                         headers: { 'Location' => "#{url}/1.html" })
      (1..12).each do |n|
        redirect_url = "#{url}/#{n}.html"
        stub_request(:head, redirect_url).to_return(status: 302, body: '',
                                                    headers: { 'Location' => redirect_url })
        expect { UrlScrapperJob.perform_now link.id }.to raise_error(ArgumentError)
      end
    end
  end
end
