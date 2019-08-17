# this is required to make htmlwidgets work with devtools

shim_system_file <- function(package) {
    imports <- parent.env(asNamespace(package))
    pkgload:::unlock_environment(imports)
    imports$system.file <- pkgload:::shim_system.file
}

shim_system_file("htmlwidgets")
shim_system_file("htmltools")
