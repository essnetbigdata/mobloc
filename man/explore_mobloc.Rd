% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/explore_mobloc.R
\name{explore_mobloc}
\alias{explore_mobloc}
\title{Explore the visualize propagation, prior, connection likelihood and location posterior probabilities per raster tile}
\usage{
explore_mobloc(cp, raster, prop, priorlist, param, filter = NULL,
  coverage_map_dBm = NULL, coverage_map_s = NULL,
  best_server_map = NULL)
}
\arguments{
\item{cp}{cellplan, validated with \code{\link{validate_cellplan}}}

\item{raster}{raster object that contains the raster tile index numbers (e.g. created with \code{\link{create_raster}})}

\item{prop}{a propagation object, which is the result of \code{\link{process_cellplan}}}

\item{priorlist}{list of priors}

\item{param}{parameter list created with \code{prop_param}}

\item{filter}{bounding box of the filter of the visualized raster. If not specified, the whole raster is shown, which could be very slow. Therefore, we recommand to use a filter when the raster covers a large area (say 30 by 30 kilometers).}

\item{coverage_map_dBm}{coverage map, created with \code{\link{create_coverage_map}} (with \code{type = "dBm"}). If not specified, it will be created (which takes some time).}

\item{coverage_map_s}{coverage map, created with \code{\link{create_coverage_map}} (with \code{type = "s"}). If not specified, it will be created (which takes some time).}

\item{best_server_map}{best server map, created with \code{\link{create_best_server_map}}. If not specified, it will be created (which takes some time).}
}
\description{
Explore the visualize propagation, prior, connection likelihood and location posterior probabilities per raster tile. When the raster is large (say larger than 30 by 30 kilometers), we recommend to specify the filter arguemnt.
}
\note{
Note that duo to the reprojection of the raster to the web mercator projection (for interactive maps), the visualized raster does not correspond exactly to the output raster.
}
\examples{
\dontrun{
# set parameters
ZL_param <- prop_param()

# load data
data("ZL_cellplan", "ZL_muni", "ZL_elevation", "ZL_landuse")

# create environment layer (needed to calculate path loss exponent (ple))
ZL_envir <- combine_raster_layers(ZL_landuse, weights = c(1, 1, 1, 0, 0))

# validate cellplan
ZL_cellplan <- validate_cellplan(ZL_cellplan, param = ZL_param, region = ZL_muni,
    envir = ZL_envir, elevation = ZL_elevation)

# create raster
ZL_bbox <- sf::st_bbox(c(xmin = 4012000, ymin = 3077000, xmax = 4048000, ymax = 3117000),
    crs = sf::st_crs(3035))
ZL_raster <- create_raster(ZL_bbox)

# process cellplan (result is propagation model and connection likelihood)
ZL_prop <- process_cellplan(cp = ZL_cellplan, raster = ZL_raster,
    elevation = ZL_elevation, param = ZL_param)

# create priors
ZL_uniform_prior <- create_uniform_prior(ZL_raster)
ZL_network_prior <- create_network_prior(ZL_prop, ZL_raster)
ZL_landuse_prior <- create_prior(ZL_landuse, weights = c(1, 1, .1, 0, .5))

# explore the results
explore_mobloc(ZL_cellplan, ZL_raster, ZL_prop, list(landuse = ZL_landuse_prior, network = ZL_network_prior, uniform = ZL_uniform_prior), param = ZL_param)
}
}
\seealso{
\href{../doc/mobloc.html}{\code{vignette("mobloc")}}
}
