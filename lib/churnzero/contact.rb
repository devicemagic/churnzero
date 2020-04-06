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
        default = {
          'attr_Email' => attributes.delete(:email),
          'attr_FirstName' => attributes.delete(:first_name),
          'attr_LastName' => attributes.delete(:last_name)
        }.compact

        # Note custom attributes are coverted to start case
        # example :message_count will become "Message Count"
        custom = {}
        attributes.each do |key, value|
          key = key.to_s.split("_").map(&:capitalize).join(" ")
          key = "attr_#{key}"
          custom[key] = value
        end
        custom = custom.compact

        # Note default attributes takes precedence
        custom.merge(default)
      end

  end
end
