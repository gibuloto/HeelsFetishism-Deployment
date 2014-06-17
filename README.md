HeelsFetishism-Deployment
=========================

SaltStack States for [HeelsFetishism](http://heelsfetishism.com/)


## States

* Ubuntu 14.04
* Django
* PostgreSQL
* nginx
* uWSGI
* Memcached
* imgSeek
* Node.js


## Usage

Place your pillar settings in `/srv/pillar/settings.sls`

``` bash
# install salt-minion
$ wget -O - http://bootstrap.saltstack.org | sudo sh

# run without salt-master
$ sudo salt-call state.highstate --local
```


[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/vinta/heelsfetishism-deployment/trend.png)](https://bitdeli.com/free "Bitdeli Badge")
