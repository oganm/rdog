zdog = readLines('https://unpkg.com/zdog@1.0.2/dist/zdog.dist.min.js')

dir.create('inst/zdog')
writeLines(zdog,'inst/zdog/zdog.min.js')
