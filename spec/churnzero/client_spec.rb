RSpec.describe Churnzero::Client do
  before do
    Churnzero.configure do |config|
      config.app_key = 'configured-app-key'
    end
  end

  describe ".new" do
    it "initializes client with the configured app_key" do
      expect(subject.instance_variable_get(:@app_key)).to eq 'configured-app-key'
    end
  end

  describe "#post" do
    it 'includes appKey when performing POST request' do
      data_before = {}
      data_after = {'appKey' => 'configured-app-key'}
      url = "https://analytics.churnzero.net/i"

      expect(Net::HTTP).to receive(:post_form).with(::URI.parse(url), data_after) { }
      subject.post(data_before)
    end

    it "removes nil values from request" do
      data_before = {"attr_FirstName" => "Foo", "attr_Email" => nil}
      data_after = {"attr_FirstName" => "Foo", "appKey" => "configured-app-key"}
      url = "https://analytics.churnzero.net/i"

      expect(Net::HTTP).to receive(:post_form).with(::URI.parse(url), data_after) { }
      subject.post(data_before)
    end
  end
end
