# Discourse METAR bot

Adds a simple METAR (and TAF) bot to discourse to give you the local weather.

See http://avwx.rest for capability. 

## Usage

In a post, type `[METAR CYVR]` - when the post it submitted, it will retrieve the weather 
report from http://avwx.rest/api/metar/CYVR 

In a post, type `[TAF CYVR]` - when the post it submitted, it will retrieve the TAF
weather prediction from http://avwx.rest/api/TAF/CYVR 

## Installation

 * Add the plugin's repo url to your container's app.yml file

```
hooks:
  after_code:
    - exec:
        cd: $home/plugins
        cmd:
          - mkdir -p plugins
          - git clone https://github.com/discourse/docker_manager.git
          - git clone https://github.com/fearlessfrog/discourse-metar-bot.git
```

 * Rebuild the container

```
cd /var/docker
git pull
./launcher rebuild app
```

## Disclaimer

**THIS IS A WORK IN PROGRESS**

Some things to look at:

 * TAF weather predictions summary
 * METAR locations 
 * Features from http://avwx.rest/documentation
 
