# MacPorts binary archives for Tiger PPC (experimental)

This is a basic GitHub Pages site to share some experimental MacPorts packages for macOS 10.4 Tiger PPC
using the mechanism described at <https://trac.macports.org/wiki/howto/ShareArchives2>

To use, add the following to the top of /opt/local/etc/macports/archive_sites.conf

```
name                glebm-macports-tiger-ppc-binary-archives
urls                http://macports-tiger-ppc.glebm.com/dist/
```

Then, download the key from <http://macports-tiger-ppc.glebm.com/dist/pubkey.pem> to
`/opt/local/share/macports/glebm-macports-tiger-ppc-binary-archives-pubkey.pem` and add it to
`/opt/local/etc/macports/pubkeys.conf`.

[Package list](http://macports-tiger-ppc.glebm.com/dist/)

### Hosting your own version

`git` does not store file mtimes.

They are not needed for MacPorts but if you'd like to keep them correct,
run `scripts/restore-mtimes.rb` after cloning.
