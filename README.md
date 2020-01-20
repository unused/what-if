# What IF

A web application that provides Interactive Fiction as a Service via
[Twine][twine] stories.

The web service uses a custom Amazon Alexa Skill to communicate and provides
narratives from Twine games as well as matches decisions to follow branching
stories.

The project has been started as a [proof of concept][poc] and I'm eager to
adapt it for a broad audience. Feedback, comments and any questions are very
welcome via [GitHub issue](https://github.com/unused/what-if/issues) or
[Twitter](https://twitter.com/lipdaguit), Regards :)

Note: I'm currently moving the project from a self-hosted kubernetes (k3s)
cluster to Heroku, and changed the database from MongoDB to Postgres.

## Alexa Skill (published asap)

The Alexa skill required to play the games is called `Storybox`. You can login
on the web interface in order to follow your progress, switch between save
games or make direct choices. Ask Alexa to login in order to retrieve a 5 digit
passcode.

The source code handling this skill can be found in `lib/alexa_handler.rb`.

## Convert a Twine Story

The service provides a `rake` task in order to preprocess and store any new
Twine story, the input file however has to be in the Twee format. With Twine
2.0 a game usually results into an HTML file format, using the nice command
line compiler [tweego] a conversion can be easily done in seconds.

```sh
# Follow this two steps to import any game into the application:
$ tweego -d storyfile.html -o storyfile.tw
$ bin/rails whatif:convert[storyfile.tw]
```

## FAQ

*Can I play any Twine game?*

Nope. But a lot of games should work just fine.

Twine allows writers to create branching stories or text games by using a very
simplified user interface. The runtime system of a Twine story is a web
browser, therefore it utilizes JavaScript and CSS for custom styling. The web
service at hand however aims to provide a much smaller application interface.
That system will run some code used from story formats, but won't interpret any
custom JavaScript at all.

If you want to run a specific game that uses a lot of extended features or
custom code feel free to contact me, I'm happy to help.

*How do I upload my own games?*

The service is prepared to automatically convert stories, yet there is no
interface implemented for this at the moment. Let me know about your game and
we'll figure out some way.

*Twine uses JavaScript why don't What IF use JavaScript?*

This is a great question that could easily lead in quite a discussion. The
project started however with JavaScript, yet never evaluated any from Twine
stories. For sure this would be a risk for any service and therefor was never
planned. As it turned out the service requires several things the prototype was
rewritten using rails in order to cover some basics.

## TODO

- [ ] Add terms & privacy infos
- [ ] Add GAME END info
- [ ] Publish AlexaRB, TweeRB and What IF
- [ ] Host What IF and add Test Content
- [ ] Link to GitHub Repository

[twine]: https://twinery.org/ "Twine, open-source software for telling interactive, nonlinear stories"
[poc]: https://en.wikipedia.org/wiki/Proof_of_concept "Proof of Concept"
[tweego]: http://www.motoslave.net/tweego/ "Twine/Twee compiler by Thomas Michael Edwards"
