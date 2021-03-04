You'll need jq and jpeg-recompress:

 * https://stedolan.github.io/jq/
 * https://github.com/danielgtaylor/jpeg-archive

Both `jq` and `jpeg-recompress` must be accessible via `PATH`.

On macOS, you should be able to install both via Homebrew:

```bash
brew install jq jpeg-archive
```
Then, run these in order:

```bash
./download.sh
./recompress.sh
./compare.sh
```

This will give you a result like so:

```
$ ./compare.sh
200: From 2.2M to 896K (39.16% of original)
400: From 8.5M to 2.7M (32.11% of original)
600: From 16M to 5.7M (34.94% of original)
843: From 32M to 11M (34.02% of original)
1686: From 52M to 13M (24.30% of original)
```
