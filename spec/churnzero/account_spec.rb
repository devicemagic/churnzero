RSpec.describe Churnzero::Account do
  subject { Churnzero::Account.new(account_uid: "acme-123", contact_uid: "foo-567", name: "ACME", custom_attribute: 'value') }

  describe ".new" do
    it "sets the correct values" do
      expect(subject.account_uid).to eq("acme-123")
      expect(subject.contact_uid).to eq("foo-567")
      expect(subject.attributes).to eq({name: "ACME", custom_attribute: "value"})
    end
  end

  describe "#save" do
    context "with all fields present" do
      it 'performs a Churnzero::Client post request with all data' do
        url = "https://analytics.churnzero.net/i"
        data = {"entity" => "account",
                "action" => "setAttribute",
                "accountExternalId" => "acme-123",
                "contactExternalId" => "foo-567",
                "attr_Name" => "ACME",
                "attr_Custom Attribute" => "value"}

        expect_any_instance_of(Churnzero::Client).to receive(:post).with(data) { }
        subject.save
      end
    end

    context "without required fields" do
      it 'raises a Churnzero::Error' do
        subject.account_uid = nil
        subject.contact_uid = nil
        expect { subject.save }.to raise_error(Churnzero::Error, /must provide a valid account_uid & contact_uid/)
      end
    end
  end
end
