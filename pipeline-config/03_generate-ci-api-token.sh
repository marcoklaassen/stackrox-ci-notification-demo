export ROX_CENTRAL_PASSWORD=$(oc get secret central-htpasswd -n rhacs --template={{.data.password}} | base64 -d)
export ROX_CENTRAL_HOST=$(oc get route central -n rhacs --template={{.spec.host}})

oc apply -f - <<END
apiVersion: v1
kind: Secret
metadata:
  name: rhacs-api-config
  namespace: rhacs-ci
type: Opaque
data:
  host: $(oc get route central -n rhacs --template={{.spec.host}} | base64)
  api-token: $(
    curl 'https://'$ROX_CENTRAL_HOST'/v1/apitokens/generate' \
     -H 'content-type: application/json' \
     -u 'admin:'$ROX_CENTRAL_PASSWORD \
     --data-raw '{"name":"ci-pipeline","roles":["Continuous Integration"]}' \
     --compressed \
     --insecure \
   | jq -r '.token' | base64)
END
