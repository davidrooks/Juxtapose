# juxtapose

 * Website: https://github.com/davidrooks/Juxtapose
 * Source: https://github.com/davidrooks/Juxtapose

Juxtapose is a screenshot comparison tool, created by David Rooks.


## What is it?

Juxtapose uses watir webdriver to create screenshots of a website and then compares
these screenshots with established baseline screenshots and identifies differences between them


## Requirements

You'll need Ruby 1.9.3 or greater.
It's up to you to decide which browser engine you want to run it against. Juxtapose has been tested against Firefox only.


## Installation

```
curl -fsSL https://raw.github.com/bskyb-commerce/juxtapose/go/install | bash
cd juxtapose
bundle install
```

## Config

All config will be placed in yml files where you can define image storage location, domain to test, screen sizes to test, browsers to use and url paths to capture

```yml

# Type the name of the directory that shots will be stored in
# Note - in order for images to be displayed by Sinatra, images
# MUST be stored under the public directory
directory:
  baseline: defines where the baseline images will be stored
  current: defines where new images will be stores


# Add only 1 domain, key will act as a label
domains:
  development: localhost:4567

#Type screen widths below, here are a couple of examples
screen_widths:
  - 320
  - 600
  - 768
  - 1024
  - 1280

#Type the browsers you want to test against.
#NOTE: chrome doesn't currently work properly as chromedriver does not take full page screenshots
#     : not tested against IE
browsers:
    - firefox
    - chrome
    - ie

#Type page URL paths below, here are a couple of examples
paths:
  home: /
  uk_index: /uk
```

## Using juxtapose

In order to start comparing baseline screenshots with new screenshots, you first need to establish a baseline:

```
rake get_baseline
```

Now you have a baseline to compare against you can grab the current state of your website:

```
rake get_current
```

Now you have a baseline and something to compare it with you can compare the images:

```
rake compare_images
```

By default the dev.yml config will be used. If you want to use a different config you can pass it in as an environment variable:

e.g.
```
rake get_baseline ENV=live
```
 #will use live.yml config

## Gallery

In order to view the gallery you will first need to start the server.

```
ruby app.rb
```

Now you can go to localhost:4567 and view the gallery.
It will only display images if there is a difference between the newest image and the baseline image.
Differences in images are clearly marked by a yellow rectangle.
If you are happy that the difference is NOT an issue then you can accept the latest screenshot as a new baseline image.

## Contributing

If you want to add functionality to this project, pull requests are welcome.

 * Create a branch based off master and do all of your changes with in it.
 * If you have to pause to add a 'and' anywhere in the title, it should be two pull requests.
 * Make commits of logical units and describe them properly
 * Check for unnecessary whitespace with git diff --check before committing.
 * If possible, submit tests to your patch / new feature so it can be tested easily.
 * Assure nothing is broken by running all the test
 * Please ensure that it complies with coding standards.

**Please raise any issues with this project as a GitHub issue.**

## Running Tests

    rspec

## Changelog - created 18/10/13
```
```


## License

juxtapose is available to everyone under the terms of the Apache 2.0 open source licence.
Take a look at the LICENSE file in the code.

## Credits

I have borrowed heavily from the BBC Wraith project

   * https://github.com/BBC-News/wraith

Twitter bootstrap credit goes to:

 * [Dave Blooman](http://twitter.com/dblooman)
 * [John Cleveley](http://twitter.com/jcleveley)
 * [Simon Thulbourn](http://twitter.com/sthulbourn)
