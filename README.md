# Churnzero

Sends accounts, contacts and events to Churnzero in order to track customer churn.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'churnzero'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install churnzero

## Usage

### Configure your app key

```ruby
# eg. config/initializers/churnzero.rb
Churnzero.configure do |config|
  config.app_key = 'ABC123DEF456ABC123DEF456ABC123DEF456'
end
```

### Accounts

```ruby
account = Churnzero::Account.new(account_uid: "acme-123", contact_uid: "foo-567", name: "ACME")
account.save
```

### Contacts

```ruby
contact = Churnzero::Contact.new(account_uid: "acme-123", contact_uid: "foo-567", email: "foo@acme.com", first_name: "Foo", last_name: "Bar")
contact.save
```

### Events

```ruby
# TODO: implement custom fields eg. cf_SomeFieldHere
event = Churnzero::Event.new(account_uid: "acme-123", contact_uid: "foo-567", event_name: "Sent Email", event_date: "1 Jan 2020 13:31", description: 'Account invite email', quantity: 3, allow_duplicates: false)
event.save
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/devicemagic/churnzero.
