Make sure helm is installed on ur laptop

1. Install wavefront

https://demo.wavefront.com/integration/kubernetes/setup


1. To enable istio metrics  (https://demo.wavefront.com/integration/istio/setup)
https://github.com/vmware/wavefront-adapter-for-istio (Deployment wont work as it is. If your kubernetes is 1.17 or above )

REPLACE YOUR-INSTANCE & YOUR-TOKEN before applying

Either fix the api version to apiVersion: apps/v1  or use config.xml from here.

Istio Dashbord metrics

https://demo.wavefront.com/u/Yf1bSTRf6d?t=demo
https://demo.wavefront.com/u/VMk4mH2X4f?t=demo


Wavefront custom metrics
https://github.com/sivarajp/catalogsvc - I built acme catalog service using go and added wavefront metrics inside (It WIP). You can feed this repo to build service. once the image is created swap in the cluster 2. Then send traffic.

These dasboard are application level metrics.

https://demo.wavefront.com/u/DT1DWQLqbr?t=demo
https://demo.wavefront.com/u/VXJZzzxRmX?t=demo
 
TODO - Get tracing working on this apps, so it will appear here.
https://demo.wavefront.com/tracing/applications#_v01(g:(d:7200,ls:!t,s:1591751479,w:'2h'))