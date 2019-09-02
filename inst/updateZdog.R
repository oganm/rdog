zdog = readLines('https://unpkg.com/zdog@1/dist/zdog.dist.min.js')

dir.create('inst/htmlwidgets/lib/zdog/')
writeLines(zdog,'inst/htmlwidgets/lib/zdog/zdog.min.js')


zfont = readLines('https://cdn.jsdelivr.net/npm/zfont/dist/zfont.min.js')
writeLines(zfont,'inst/htmlwidgets/lib/zdog/zfont.min.js')



paper = readLines('https://cdnjs.cloudflare.com/ajax/libs/paper.js/0.12.0/paper-full.min.js')
writeLines(paper,'inst/htmlwidgets/lib/zdog/paper-full.min.js')

# can't use. incompatible license
# required my morphSVG
# TweenMax = readLines('https://cdnjs.cloudflare.com/ajax/libs/gsap/2.1.3/TweenMax.min.js')
# writeLines(TweenMax,'inst/htmlwidgets/lib/zdog/TweenMax.min.js')
#
# MorphSVGPlugin = readLines('https://s3-us-west-2.amazonaws.com/s.cdpn.io/16327/MorphSVGPlugin.min.js')
# writeLines(MorphSVGPlugin,'inst/htmlwidgets/lib/zdog/MorphSVGPlugin.min.js')
