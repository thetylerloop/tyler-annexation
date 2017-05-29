library(dplyr)
library(rgdal)
library(ggplot2)
library(ggthemes)

annexations <- readOGR("data/with_area/with_area.shp")

areas <- data.frame(year = numeric(), area_sq_m = numeric())

ggplot() +
  geom_polygon(data = annexations, aes(x = long, y = lat, group = group)) +
  coord_fixed(xlim = c(272000, 295000), ylim = c(3567000, 3595000)) +
  annotate("text", x = 275000, y = 3568000, label = "2017") + 
  theme_map() +
  ggsave("animation/2017.png")

for (i in seq(1940, 2017, 10)) {
  print(i)
  tyler <- subset(annexations, YEAR < i)
  
  areas[nrow(areas) + 1, ] <- c(i, sum(tyler$AREA))
  
  ggplot() +
    geom_polygon(data = tyler, aes(x = long, y = lat, group = group)) +
    coord_fixed(xlim = c(272000, 295000), ylim = c(3567000, 3595000)) +
    annotate("text", x = 275000, y = 3568000, label = i) + 
    theme_map() +
    ggsave(paste0("animation/", i, ".png"))
}

areas <- areas %>%
  mutate(area_sq_mi = area_sq_m * 0.0000003861022)