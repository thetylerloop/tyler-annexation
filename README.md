# tyler-annexation

Analysis & graphics illustrating Tyler's historical growth.

## Usage

Generating GIF:

```
convert -resize '1188x827>' -delay 100 -loop 0 animation/*.png animation/animation.gif
```

Generating TopoJSON:

```
topojson data/with_area/with_area.shp --out annexations.json --properties YEAR
```

## Sources

City of Tyler FOIA request.