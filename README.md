# rdog

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
devtools::load_all()
```

This is a port of the [zdog](https://zzz.dog/) pseudo 3D engine for R. Currently
a work in progres.

## Installation

```r
devtools::install_github('oganm/rdog')
```

Install the latest Rstudio to make sure it works well with the built in viewer.
Some elements appears to misbehave in older versions.


## Why?

...

## Basic usage

```{r}
illustration('illo',dragRotate = TRUE) %>% 
    shape_ellipse(id = 'hede',color = 'red',stroke = 20,width = 120,height = 120,fill = FALSE) %>%
    shape_rect(width = 50, height = 50,stroke = 20, fill = FALSE,rotate = c(z=tau/8)) %>%
    zfont_font(id = 'font') %>% 
    zfont_text(zfont = 'font',text = 'Text',fontSize = 50,
               textAlign = 'center',stroke = 4,translate = c(y = 110)) %>%
    # animation_none()
    animation_rotate(rotate = c(y = .05))
```

![](README_files/rotate.gif)

## Use in shiny

WIP. Currently a little broken


## Use as shiny inputs

WIP
