module Churnzero
  class Contact
    attr_accessor :account_uid, :contact_uid, :attributes

    def initialize(account_uid: nil, contact_uid: nil, **attributes)
      @account_uid = account_uid
      @contact_uid = contact_uid
      @attributes = attributes
    end

    def save
      validate
      data = mapped_attributes.merge({'action' => 'setAttribute',
                                      'entity' => 'contact',
                                      'accountExternalId' => account_uid,
                                      'contactExternalId' => contact_uid})
      Client.new.post(data)
    end

    private

      def validate
        errors = []
        ["account_uid", "contact_uid"].each do |attribute|
          errors << attribute if self.send(attribute).nil?
        end
        raise Error.new("You must provide a valid #{errors.join(' & ')}") if errors.any?
      end

      def mapped_attributes
        {
          'attr_Email' => attributes[:email],
          'attr_FirstName' => attributes[:first_name],
          'attr_LastName' => attributes[:last_name]
        }.compact
      end

  end
end
