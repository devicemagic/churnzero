module Churnzero
  class Event
    attr_accessor :account_uid, :contact_uid, :event_name, :attributes

    def initialize(account_uid: nil, contact_uid: nil, event_name: nil, **attributes)
      @account_uid = account_uid
      @contact_uid = contact_uid
      @event_name = event_name
      @attributes = attributes
    end

    def save
      validate
      data = mapped_attributes.merge({'action' => 'trackEvent',
                                      'accountExternalId' => account_uid,
                                      'contactExternalId' => contact_uid,
                                      'EventName' => event_name})
      Client.new.post(data)
    end

    private

      def validate
        errors = []
        ["account_uid", "contact_uid", "event_name"].each do |attribute|
          errors << attribute if self.send(attribute).nil?
        end
        raise Error.new("You must provide a valid #{errors.join(' & ')}") if errors.any?
      end

      def event_date
        begin
          Time.parse(attributes[:event_date].to_s).iso8601
        rescue
          nil
        end
      end

      def mapped_attributes
        {
          'EventDate' => event_date,
          'description' => attributes[:description],
          'quantity' => attributes[:quantity],
          'allowDupes' => attributes[:allow_duplicates]
        }.compact
      end

  end
end
