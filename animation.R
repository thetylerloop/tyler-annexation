library(dplyr)
library(rgdal)
library(ggplot2)
library(ggthemes)

annexations <- readOGR("data/with_area/with_area.shp")
annexations@data$id <- rownames(annexations@data)

df <- fortify(annexations, region = "id")
df <- merge(df, annexations@data, by = "id")

areas <- data.frame(year = numeric(), area_sq_m = numeric())

df$addition = df$YEAR >= 2010

ggplot() +
  geom_polygon(data = df, aes(x = long, y = lat, group = group, fill = addition)) +
  coord_fixed(xlim = c(272000, 295000), ylim = c(3567000, 3595000)) +
  annotate("text", x = 275000, y = 3568000, label = "2017") + 
  theme_map() +
  guides(fill = FALSE) + 
  ggsave("animation/2017.png")

for (i in seq(1940, 2017, 10)) {
  print(i)
  tyler <- subset(df, YEAR < i)
  
  tyler$addition <- tyler$YEAR >= i - 10

  area <- tyler %>%
    group_by(id) %>%
    filter(row_number() == 1) %>%
    ungroup() %>%
    summarise(total = sum(AREA))
  
  areas[nrow(areas) + 1, ] <- c(i, area$total)
  
  ggplot() +
    geom_polygon(data = tyler, aes(x = long, y = lat, group = group, fill = addition)) +
    coord_fixed(xlim = c(272000, 295000), ylim = c(3567000, 3595000)) +
    annotate("text", x = 275000, y = 3568000, label = i) + 
    theme_map() +
    guides(fill = FALSE) + 
    ggsave(paste0("animation/", i, ".png"))
}

areas[nrow(areas) + 1, ] <- c(2017, sum(annexations@data$AREA))

areas <- areas %>%
  mutate(area_sq_mi = area_sq_m * 0.0000003861022)

write.csv(areas, "results/areas.csv", row.names = FALSE)
