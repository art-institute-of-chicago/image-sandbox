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
200: From 2.2M to 896K (39.16% of original) (File count: 49, 49) (Avg Size/File: 46.7K to 18.3K)
400: From 8.5M to 2.7M (32.11% of original) (File count: 49, 49) (Avg Size/File: 178.5K to 57.4K)
600: From 16M to 5.7M (34.94% of original) (File count: 49, 49) (Avg Size/File: 339.7K to 118.7K)
843: From 32M to 11M (34.02% of original) (File count: 49, 49) (Avg Size/File: 658.4K to 224.0K)
1686: From 52M to 13M (24.30% of original) (File count: 19, 19) (Avg Size/File: 2.8M to 683.6K)
```

The file counts (old, new) are just there as a sanity check to ensure all images got recompressed.

If the files you downloaded are at quality 100, you can also compare 100 vs. 95, and 95 vs recompressed.

First, run this to populate `images/q95`:

```bash
./to-q95.sh
```

File savings from 100 vs. 95:

```
$ ./compare.sh downloaded q95
200: From 2.2M to 1.1M (48.43% of original) (File count: 49, 49) (Avg Size/File: 46.7K to 22.7K)
400: From 8.5M to 3.6M (42.09% of original) (File count: 49, 49) (Avg Size/File: 178.5K to 75.2K)
600: From 16M to 7.6M (46.50% of original) (File count: 49, 49) (Avg Size/File: 339.7K to 158.0K)
843: From 32M to 14M (45.62% of original) (File count: 49, 49) (Avg Size/File: 658.4K to 300.4K)
1686: From 52M to 21M (40.11% of original) (File count: 19, 19) (Avg Size/File: 2.8M to 1.2M)
```

File savings from 95 vs. recompressed:

```
$ ./compare.sh q95 recompressed
200: From 1.1M to 896K (80.87% of original) (File count: 49, 49) (Avg Size/File: 22.7K to 18.3K)
400: From 3.6M to 2.7M (76.30% of original) (File count: 49, 49) (Avg Size/File: 75.2K to 57.4K)
600: From 7.6M to 5.7M (75.14% of original) (File count: 49, 49) (Avg Size/File: 158.0K to 118.7K)
843: From 14M to 11M (74.59% of original) (File count: 49, 49) (Avg Size/File: 300.4K to 224.0K)
1686: From 21M to 13M (60.58% of original) (File count: 19, 19) (Avg Size/File: 1.2M to 683.6K)
3000: From 47M to 23M (49.22% of original) (File count: 19, 19) (Avg Size/File: 2.5M to 1.3M)
```
