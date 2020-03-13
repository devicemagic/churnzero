RSpec.describe Churnzero::Client do
  describe ".new" do
    it "initializes client with the configured app_key" do
      expect(subject.instance_variable_get(:@app_key)).to eq 'configured-app-key'
    end
  end

  describe "#post" do
    context "when app_key is nil" do
      it 'raises a Churnzero::Error' do
        allow(Churnzero).to receive(:configuration) { OpenStruct.new(app_key: nil) }
        expect { subject.post({}) }.to raise_error(Churnzero::Error, /app_key is nil/)
      end
    end

    context "when app_key is present" do
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
end
