# VE3MAL Ham Radio Website
Static html website for amateur radio stuff

Bare static web pages are in /src. They begin with a number and underscore.
This determines the order they will be in the menu.

/bin contains two perl scripts and a bash script that runs them both.
Running that will generate menues and place the html files
in /doc for use in github pages as a static website.

Images placed in /gallery will be included in an image gallery page. Any
images required for other pages that should /not/ be in gallery

Roadmap:
- [x] Get a menu-generating script working
- [x] favicon
- [x] custom dns
- [ ] ssl
- [x] Basic layout/skeleton
- [ ] Gallery page generating
- [ ] Don't update page date unless content changed
- [ ] About page content
- [ ] other content
