Properties
==========

A small app in Elixir that will filter some [Idealista](http://www.idealista.com/) flats to clean them enough to be sent to [CartoDB](https://cartodb.com/).

Compilation
-----------

    mix escript.build
    
    
Prereqs
-------

You will need Idealista and Google Directions API access.

For Idealista, request access here: http://developers.idealista.com/access-request

For Google, go here: https://console.cloud.google.com/apis/api/directions_backend/overview

Usage
-----

Now that you have the access, you will need to set 3 environment vars:

- `IDEALISTA_APIKEY`
- `IDEALISTA_SECRET`
- `GOOGLE_APIKEY`

And finally, run it!

    ./properties

The output of this command is going to be a CSV that you can easily drag&drop on CartoDB.

Result
------

Idealista have some shared datasets on CartoDB, you can use them to for example add underground stations and lines. After some tweaking there you can end up with something like this:

![](cartodb.png)

TODO
----

- Directly send (and update!) the properties to CartoDB.
- Have some fun with the tests.
- Fix (ask) some of the TODOs.
