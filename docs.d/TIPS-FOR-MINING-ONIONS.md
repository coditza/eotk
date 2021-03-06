# Tips when mining Onion Addresses

## for v2 and v3 onion addresses; updated 26 jun 2019

* Copied from:
  https://medium.com/@alecmuffett/tips-when-mining-onion-addresses-8eece14cbd95

Congratulations! You are setting up an Onion site! And you want a
vanity onion address! There is lots of software out there that you can
use to generate them!

I'm not going to make strong software recommendations, because it's a
matter of what you have at your disposal already, and what fits the
hardware that you have access to.

* for v2: Onions: `Scallion` (C# or Mono, GPU accelerated), `Shallot`,
  or `Eschalot`; go for the latest versions of each.

* for v3 Onions: I have no idea of the standout tools, please check
  back and/or suggest something in the comments

Some people mine onion addresses on local hardware for safety, others
are happy to rent a GPU-based compute-heavy instance from AWS, or
similar.

If you're setting up multiple onions for your site -- eg: if there is
one/more CDNs associated with your site, it is nice to set up vanity
onions for them, too; partly for "cute" but also to stop yourself
going crazy during debugging.

For instance, the NYT onion is https://www.nytimes3xbfgragh.onion/ and
their CDN Onion is https://graylady3jvrrxbe.onion/

Similarly there exist https://www.facebookcorewwwi.onion/ and
https://fbcdn23dssr3jqnq.onion/

* Perhaps use your CDN Onion to reflect your own history and
site/brand culture?

Onion mining is a matter of luck and resource, and
(counterintuitively?)  the rarest resource that you have, is time, as
measured by your wall clock.

Therefore, if you are mining onions for a lot of sites, the best
strategy is follows:

* Have breakfast and some tea or coffee. Try to get into a creative
  mood.

* Sit down, open a document, and try to think inclusively of every
  possible prefix that you might ever find acceptable at the start (or
  finish) of your onion addresses, for all of your sites, and write
  them all down. You may create 10, 20, or more. No ideas are bad
  ideas. Deduplicate them (eg: it's pointless to look especially for
  `nytimes` if you are already happy to have anything beginning with
  `nyt`)

* Configure your software to search for all of these, for all of your
  sites, simultaneously. Set it running. Make sure to configure
  options (or: wrap it in a shellscript) so that it runs 24x7, saving
  all the successful matches into the local filestore.

* If/when you think of yet another prefix, stop your software,
  configure the extra prefix, and start it running again. Save all of
  the successful matches, never throw anything away.

* When you are approaching ship-date, get all the relevant parties
  together (or just yourself) and grab some beer/wine and use `grep`
  to go looking for the best ones. Eyeball the whole list, if you can.

* You will be surprised -- especially if you've invested fully into
  choosing as many meaningful prefixes as possible -- because you're
  dealing with randomness here, and raw entropy is more creative than
  you'd ever imagine.

* There is also a vast amount of noise -- huge, enormous quantities
  of gibberish -- but that's okay, because `storage+grep` is cheaper
  than `encryption+wallclocktime`.

* When we mined the Facebook onion address, the search-patterns were
  `^(facebook|fbcdn|fbsbx|...)` and a few others all in a single
  pattern.  We drank beer and spent a few days deciding amongst the
  good ones.

* Similarly the pattern for the nytimes was
  `^(nytimes|nytcdn|nytwww|graylady|...)` and a few other potential
  prefixes, perhaps a dozen, all in one pattern; and I mined onion
  addresses for other sites at the same time, on the same hardware, in
  the same process.

* Why do it this way? In short, because encryption is relatively
  expensive, and string comparisons are really cheap. Every single
  candidate onion address that you generate, should be tested against
  everything that you can imagine ever looking for, otherwise it's a
  wasted opportunity.

* Ideally, make sure that you are thoroughly in control of the backups
  and storage of the machine upon which you are doing the mining; try
  to use an encrypted partition if you can

* Ensure that you have proper controls over all media which ever
  receives a copy of the Onion address key.

Best of luck to you. :-)

## War Stories and Problems When Mining Onions

A long time ago I mined a bunch of test onion addresses for the New
York Times, and I put a few into test deployment; and one of them did
not work, like, at all.  I had mined them all using Shallot on
Raspbian/Debian, and I had hundreds to pick from, but one of the nice
ones was something like `foofoofoofoofoo.onion`

Or, at least, Shallot had told me that the key *was* `foofoofoofoofoo`
-- but when I checked the `hostname` file in the relevant Tor config,
it said that the respective onion address was something else entirely
(eg: `barbarbarbarbar.onion`).  I thought: this is crazy, but I
tracked it all the way back to the miner, and (in short) the contents
of the file did not match what Shallot said it was.

`Shallot` had lied.

So if you mine Onion Addresses, beware, and always test them
thoroughly, especially **before** buying SSL Certificates which cite
them.

### The Technical Bit

For technical reasons[1] EOTK now manually recreates the expected,
rather than actual, `hostname` file during install; so it might not
reflect reality if your V2 onion keys are thusly afflicted - for
instance if your Onion site is 100% unreachable.

The way to test a **V2 Onion** address for this syndrome is to `cd`
into `projects.d/.../foofoofoofoofoo.d/` and then **remove** the
`hostname` file in that directory.

Then do:

* `eotk shutdown && eotk start -a`

...which will regenerate that file.  Check that it matches your
expectation, and if not, discard that vanity address and start over.

Interestingly it appears that this behaviour (contents of a
regenerated `hostname` file may not necessarily match expectation)
appears to be the norm for V3 onion addresses, presumably because
elliptic curve cryptography, hence why I manually generate the
hostname files in recent versions of EOTK.  I need to talk to Tor
more, to find out if I am misapprehending regarding this latter.
