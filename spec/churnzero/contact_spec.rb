RSpec.describe Churnzero::Contact do
  before do
    Churnzero.configure do |config|
      config.app_key = 'configured-app-key'
    end
  end

  subject { Churnzero::Contact.new(account_uid: "acme-123", contact_uid: "foo-567", email: "foo@acme.com", first_name: "Foo", last_name: "Bar") }

  describe ".new" do
    it "sets the correct values" do
      expect(subject.account_uid).to eq("acme-123")
      expect(subject.contact_uid).to eq("foo-567")
      expect(subject.attributes).to eq({email: "foo@acme.com", first_name: "Foo", last_name: "Bar"})
    end
  end

  describe "#save" do
    context "with all fields present" do
      it 'performs a Churnzero::Client post request with all data' do
        url = "https://analytics.churnzero.net/i"
        data = {"entity" => "contact",
                "action" => "setAttribute",
                "accountExternalId" => "acme-123",
                "contactExternalId" => "foo-567",
                "attr_FirstName" => "Foo",
                "attr_LastName" => "Bar",
                "attr_Email" => "foo@acme.com"}

        expect_any_instance_of(Churnzero::Client).to receive(:post).with(data) { }
        subject.save
      end
    end

    context "without required fields" do
      it 'raises a Churnzero::Error' do
        subject.account_uid = nil
        subject.contact_uid = nil
        expect { subject.save }.to raise_error(Churnzero::Error, /You must provide a valid/)
      end
    end
  end
end
