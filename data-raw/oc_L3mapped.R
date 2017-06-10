# The authors thank the Ocean Biology Processing Group (Code 614.2)  at the GSFC, Greenbelt, MD 20771, 
# for the production and distribution of the ocean color data.
# 
# This set includes the smallest found L3bin file from the ocean colour archive (2014-08-01): 
#   http://oceandata.sci.gsfc.nasa.gov/SeaWiFS/L3BIN/2008/001
#  
# Here we use L3m not L3b from the roc package. 
# 
# The files can be requested directly with a getfile request like: 
#
# Copied from ncdump R package 2017-06-11 - changed to https

f <- "https://oceandata.sci.gsfc.nasa.gov/cgi/getfile/S2008001.L3m_DAY_CHL_chlor_a_9km.nc"
curl::curl_download(f, file.path("inst", "extdata",  basename(f)), mode = "wb")
