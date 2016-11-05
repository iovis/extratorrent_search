require 'spec_helper'

describe ExtratorrentSearch::Search do
  subject { build :search }
  let(:search_failed) { build :search_failed }
  let(:url) { 'https://extratorrent.cc/search/?search=the%20big%20bang%20theory%20s10e06&srt=seeds&order=desc' }
  let(:url_failed) { 'https://extratorrent.cc/search/?search=the%20big%20bang%20theory%20s10e66&srt=seeds&order=desc' }

  before(:each) do
    stub_request(:get, url).to_return File.new('spec/http_stubs/extratorrent_successful_search.http')
    stub_request(:get, url_failed).to_return File.new('spec/http_stubs/extratorrent_failed_search.http')
  end

  it 'generates the search url' do
    expect(subject.url).to eq(url)
  end

  context '#results_found?' do
    it 'is true if results are found' do
      expect(subject.results_found?).to be_truthy
    end

    it 'is false if no results are found' do
      expect(search_failed.results_found?).to be_falsy
    end
  end

  context '#links' do
    it "generates #{ExtratorrentSearch::Search::NUMBER_OF_LINKS} links" do
      expect(subject.links.size).to eq(ExtratorrentSearch::Search::NUMBER_OF_LINKS)
    end

    it 'generates Link instances' do
      expect(subject.links).to all(be_a(ExtratorrentSearch::Link))
    end

    it 'returns an empty list if no results found' do
      expect(search_failed.links).to eq([])
    end
  end
end
