# Acts As Trackable

This plugin provides a simple way to track users actions.

- Allow any model to be tracked.
- Allow any model to track. In other words, tracker do not have to come from a user, they can come from any model (such as a Group or Team).
- Provide an easy to track/untrack syntax.

## Installation

### Rails 4+

Add this line to your application's Gemfile:

    gem 'acts_as_trackable'
    gem 'acts_as_trackable', :git => "https://github.com/cloudbsd/acts_as_trackable.git"

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install acts_as_trackable

### Database Migrations

    $ rails generate acts_as_trackable:migration
    $ rake db:migrate

## Usage

### Trackable Models

    example:
    you have User and Post models, you hope to add favorite feature

    add acts_as_tracker
    acts_as_tracker_on favorite_posts

    favorite, unfavorite, favorite? methods will be generated.

    name with '_' is NOT allowed


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
