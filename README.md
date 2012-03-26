Flameeyes's Static Web Site
===========================

Welcome to my personal collection of XSLT helper templates to generate
a complete static website starting from very simple XML data files.

Unfortunately, while I was finally able to opensource this, I haven't
been able to properly set up documentation an example, but I hope to
do so in the next weeks.

Getting the sources
-------------------

If you're receiving this from a website that uses FSWS, you might
wonder which one is the main and original repository for the project.

You can find the sources on [my GitHub
repository](http://github.com/Flameeyes/fsws) and the details of my
project on [my website](http://www.flameeyes.eu/projects/fsws) (which
uses FSWS itself).

Prerequisites
-------------

Right now the templates are designed to be generic, but are only
tested with `xsltproc` as provided by
[libxslt](http://xmlsoft.org/XSLT/).

In the future there might be feature depending on shared object
extensions for libxslt, so that will remain the main supported
implementation.

License
-------

The project is released under the GNU AGPL version 3, plus an
exception I'll call “FSWS Exception” and is derived from the Autoconf
exception written by the Free Software Foundation.

You can find the license and exception distributed in the repository
as `COPYING` and `COPYING.EXCEPTION`.

As a quick reference, you can make your own websites with FSWS, but if
you change the content of this repository to do so, you should make it
available to whomever can see your website.

Without going into all the possible legalities of it, if you do change
this repository, simply add a link at the bottom of the page “Powered
by FSWS” linking back to _your_ forked repository with the modified
templates.

You need not to publish your XML data or the main template
provided. You also don't have to publish your extension templates.
