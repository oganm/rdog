% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/internals.R, R/shapes.R
\name{anchor}
\alias{anchor}
\alias{internal_anchor}
\title{Common anchor arguments}
\usage{
internal_anchor(addTo, translate = c(x = 0, y = 0, z = 0), rotate = c(x
  = 0, y = 0, z = 0), scale = c(x = 1, y = 1, z = 1))

anchor(rdog = NULL, id = NULL, addTo = NULL, translate = c(x = 0, y
  = 0, z = 0), rotate = c(x = 0, y = 0, z = 0), scale = c(x = 1, y = 1,
  z = 1))
}
\arguments{
\item{addTo}{Id of the parent object. If an rdog object is piped and
addTo is set to NULL, the default parent will be the illustration itself.}

\item{translate}{Position relative to the origin. Origin point is defined based
on \code{addTo} parameter. A vector with named x, y, z elements.}

\item{rotate}{Set rotation. Unit is radians. Use with \code{\link[base]{pi}} constant. A vector with named x, y, z elements.}

\item{scale}{Scale dimensons. Can be an unnamed integer or a vector with named x, y ,z elements}

\item{rdog}{rdog object to add the shape to. Can be a character if called from a code block in shiny}

\item{id}{id of the anchor. If NULL, a random id will be assigned}
}
\description{
Common anchor arguments

Anchor
}
\keyword{internal}
