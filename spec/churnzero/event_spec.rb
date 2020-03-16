RSpec.describe Churnzero::Event do
  let(:event_date) { '19 April 1943 13:15' }
  subject { Churnzero::Event.new(account_uid: "acme-123", contact_uid: "foo-567", event_name: "Sent Email", event_date: event_date, description: 'Join team ACME', quantity: 3) }

  describe ".new" do
    it "sets the correct values" do
      expect(subject.account_uid).to eq("acme-123")
      expect(subject.contact_uid).to eq("foo-567")
      expect(subject.event_name).to eq("Sent Email")
      expect(subject.attributes).to eq({event_date: event_date, description: "Join team ACME", quantity: 3})
    end
  end

  describe "#save" do
    context "with all fields present" do
      it 'performs a Churnzero::Client post request with all data' do
        url = "https://analytics.churnzero.net/i"
        data = {"action" => "trackEvent",
                "accountExternalId" => "acme-123",
                "contactExternalId" => "foo-567",
                "eventName" => "Sent Email",
                "eventDate" => Time.parse(event_date).iso8601,
                "description" => "Join team ACME",
                "quantity" => 3}

        expect_any_instance_of(Churnzero::Client).to receive(:post).with(data) { }
        subject.save
      end
    end

    context "without required fields" do
      it 'raises a Churnzero::Error' do
        subject.account_uid = nil
        subject.contact_uid = nil
        subject.event_name = nil
        expect { subject.save }.to raise_error(Churnzero::Error, /must provide a valid account_uid & contact_uid & event_name/)
      end
    end
  end
end
